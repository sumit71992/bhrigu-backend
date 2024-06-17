import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import * as Helper from "../services/HelperFunction.js";
import * as validateUser from "../services/SchemaValidate/userSchema.js";
import { Constants } from "../services/Constants.js";
import { getUser } from "../services/userService.js";
import { prisma } from "../app.js";

export const signup = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.signupSchema, req.body, res))
      return;
    const { password, email, mobileNumber, ...restBody } = req.body;
    const otp = Helper.generateOTP();
    let [emailRegistered, isUserName, userRole] = await Promise.all([
      prisma.user.findUnique({
        where: {
          email: email?.toLowerCase(),
        },
      }),
      prisma.user.findUnique({
        where: {
          mobileNumber,
        },
      }),
      prisma.role.findUnique({ where: { name: "user" } }),
    ]);
    if (!userRole) {
      const role = await prisma.role.create({ data: { name: "user" } });
      userRole = role;
    }
    if (isUserName) {
      return Helper.errorMsg(res, Constants.MOBILE_EXIST, 200);
    }
    if (emailRegistered) {
      return Helper.errorMsg(res, Constants.EMAIL_EXIST, 200);
    } else {
      const hashedPwd = await bcrypt.hash(password, 10);
      await prisma.$transaction(async (prisma) => {
        const user = await prisma.user.create({
          data: {
            ...restBody,
            email: email.toLowerCase(),
            mobileNumber: mobileNumber,
            password: hashedPwd,
            roleId: userRole.id,
          },
        });
        const otpRes = await prisma.otp.create({
          data: {
            userId: user.id,
            otp: otp,
          },
        });
        if (!otpRes)
          return Helper.errorMsg(res, Constants.SOMETHING_WRONG, 200);
        const messagebody = `Your signup otp is: ${otp}`;
        // await Helper.sendMessage("+919304242964", messagebody);
        Helper.sendEmail(user.email, messagebody, "Signup OTP");
        // return Helper.successMsg(res, Constants.OTP_SENT_MOBILE, user);
        return Helper.successMsg(res, Constants.SIGNUP, user);
      });
    }
  } catch (err) {
    console.log(err);
    return Helper.errorMsg(res, err, 500);
  }
};
export const verifyOTP = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.otpSchema, req.body, res)) return;
    const { email, otp, type, userId } = req.body;
    const user = email
      ? await prisma.user.findUnique({
          where: { email: email.toLowerCase() },
          include: { role: { select: { name: true } } },
        })
      : await prisma.user.findUnique({
          where: { id: userId },
          include: { role: { select: { name: true } } },
        });
    if (user) {
      const isExpired = await prisma.otp.findUnique({
        where: { userId: user.id },
      });
      if (type === "SIGNUP") {
        if (
          !isExpired ||
          (isExpired && isExpired.otp !== otp) ||
          (isExpired && isExpired.type !== Constants.OTP_TYPE_SIGNUP)
        ) {
          return Helper.warningMsg(res, Constants.INVALID_OTP);
        }
        if (isExpired.status !== Constants.ACTIVE) {
          return Helper.errorMsg(res, Constants.OTP_EXPIRED, 200);
        }
        const currentTime = Date.now();
        const checkTime = new Date(isExpired?.updatedAt);
        if (currentTime - checkTime.getTime() > 15 * 60 * 1000) {
          await prisma.otp.update({
            where: {
              userId: user.id,
            },
            data: {
              status: Constants.INACTIVE,
            },
          });
          return Helper.errorMsg(res, Constants.OTP_EXPIRED, 200);
        }
        const result = await prisma.otp.update({
          where: {
            userId: user.id,
          },
          data: {
            status: Constants.INACTIVE,
          },
        });
        if (!result) {
          return Helper.warningMsg(res, Constants.INVALID_OTP);
        }

        const token = Helper.authUser(
          {
            id: user.id,
            email: user.email,
          },
          "15d"
        );
        const refreshToken = Helper.authUser(
          {
            id: user.id,
            email: user.email,
          },
          "30d"
        );
        await prisma.user.update({
          where: {
            id: user.id,
          },
          data: {
            status: Constants.ACTIVE,
          },
        });
        const resultData = {
          id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          name: user.firstName + " " + user.lastName,
          userName: user.userName,
          role: user.role.name,
          email: user.email,
          online: user.online,
          token,
          refreshToken,
        };
        return Helper.successMsg(res, Constants.SIGNUP, resultData);
      } else if (type === "FORGOT") {
        if (!isExpired) {
          return Helper.warningMsg(res, Constants.INVALID_OTP);
        }
        if (
          !isExpired ||
          (isExpired && isExpired.otp !== otp) ||
          (isExpired && isExpired.type !== Constants.OTP_TYPE_FORGOT)
        ) {
          return Helper.warningMsg(res, Constants.INVALID_OTP);
        }
        if (isExpired.status !== Constants.ACTIVE) {
          return Helper.errorMsg(res, Constants.OTP_EXPIRED, 200);
        }
        const currentTime = Date.now();
        const checkTime = new Date(isExpired?.updatedAt);
        if (currentTime - checkTime.getTime() > 15 * 60 * 1000) {
          await prisma.otp.update({
            where: {
              userId: user.id,
            },
            data: {
              status: Constants.INACTIVE,
            },
          });
          return Helper.errorMsg(res, Constants.OTP_EXPIRED, 200);
        }
        const result = await prisma.otp.update({
          where: {
            userId: user.id,
          },
          data: {
            status: "INPROGRESS",
          },
        });

        if (!result) {
          return Helper.warningMsg(res, Constants.INVALID_OTP);
        }

        return Helper.successMsg(res, Constants.OTP_VERIFIED, result);
      }
    } else {
      return Helper.warningMsg(res, Constants.WRONG_EMAIL);
    }
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};
export const resendOtp = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.userIdSchema, req.body, res))
      return;
    const { userId } = req.body;
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (user) {
      const otp = Helper.generateOTP();
      const result = await prisma.otp.update({
        where: { userId: user.id },
        data: { otp },
      });
      const messagebody = `Your ${result.type} otp is: ${otp}`;
      // await Helper.sendMessage("+919304242964", messagebody);
      Helper.sendEmail(user.email, messagebody, "Resend OTP");
      if (result) {
        return Helper.successMsg(res, Constants.OTP_SENT_EMAIL, {});
      } else {
        return Helper.errorMsg(res, Constants.SOMETHING_WRONG, 200);
      }
    } else {
      return Helper.errorMsg(res, Constants.INVALID_ID, 401);
    }
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};

export const signin = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.loginSchema, req.body, res)) return;
    const { email, password } = req.body;

    const usr = await prisma.user.findUnique({
      where: {
        email: email.toLowerCase(),
      },
      include: {
        role: {
          select: {
            name: true,
          },
        },
      },
    });
    if (!usr) {
      return Helper.warningMsg(res, Constants.WRONG_EMAIL);
    } else if (usr.status === Constants.INACTIVE) {
      return Helper.warningMsg(res, Constants.BLOCKED);
    } else if (usr.status === "EMAILOTPREQUIRED") {
      const otp = Helper.generateOTP();
      await prisma.otp.upsert({
        where: {
          userId: usr.id,
        },
        update: {
          otp,
          status: Constants.ACTIVE,
        },
        create: {
          userId: usr.id,
          otp,
          type: Constants.OTP_TYPE_SIGNUP,
          status: Constants.ACTIVE,
        },
      });
      const result = await bcrypt.compare(password, usr.password);
      if (!result) {
        return Helper.warningMsg(res, Constants.INCORRECT_PASSWORD);
      }
      const messagebody = `Your signup otp is: ${otp}`;
      // await Helper.sendMessage("+919304242964", messagebody);
      Helper.sendEmail(usr.email, messagebody, "Signup OTP");
      return Helper.successMsg(res, Constants.OTP_SENT_EMAIL, {
        requireVerification: true,
      });
    } else {
      const result = await bcrypt.compare(password, usr.password);
      if (!result) {
        return Helper.warningMsg(res, Constants.INCORRECT_PASSWORD);
      }

      const token = Helper.authUser(
        {
          id: usr.id,
          email: usr.email,
        },
        "15d"
      );
      const refreshToken = Helper.authUser(
        {
          id: usr.id,
          email: usr.email,
        },
        "30d"
      );
      const resultToSend = {
        id: usr.id,
        firstName: usr.firstName,
        lastName: usr.lastName,
        name: usr.firstName + " " + usr.lastName,
        userName: usr.userName,
        role: usr.role.name,
        email: usr.email,
        online: usr.online,
        token,
        refreshToken: refreshToken,
      };
      return Helper.successMsg(res, Constants.LOGIN_SUCCESS, resultToSend);
    }
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};
export const forgotPassword = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.emailSchema, req.body, res)) return;
    const { email } = req.body;
    const otp = Helper.generateOTP();
    const user = await getUser(null, email.toLowerCase(), null, null);

    if (!user) {
      return Helper.errorMsg(res, Constants.WRONG_EMAIL, 200);
    }
    if (user.status === Constants.INACTIVE) {
      return Helper.errorMsg(res, Constants.BLOCKED, 200);
    }
    if (user.status === "EMAILOTPREQUIRED") {
      return Helper.errorMsg(res, "Login to verify otp", 200);
    }
    const otpRes = await prisma.otp.upsert({
      where: {
        userId: user.id,
      },
      update: {
        otp,
        status: Constants.ACTIVE,
        type: Constants.OTP_TYPE_FORGOT,
      },
      create: {
        userId: user.id,
        otp,
        status: Constants.ACTIVE,
        type: Constants.OTP_TYPE_FORGOT,
      },
    });
    if (!otpRes) return Helper.warningMsg(res, Constants.SOMETHING_WRONG);
    const messagebody = `Your forgot password otp is: ${otp}`;
    // await Helper.sendMessage("+919304242964", messagebody);
    Helper.sendEmail(user.email, messagebody, "Forgot Password OTP");
    return Helper.successMsg(res, Constants.OTP_SENT_EMAIL, user);
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};

export const resetPassword = async (req, res) => {
  try {
    if (Helper.validateRequest(validateUser.resetSchema, req.body, res)) return;
    const { otp, userId, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const isExpired = await prisma.otp.findUnique({ where: { userId } });

    if (isExpired?.otp !== otp || isExpired.status !== "INPROGRESS") {
      return Helper.errorMsg(res, Constants.INVALID_OTP, 200);
    }
    const currentTime = Date.now();
    const checkTime = new Date(isExpired?.updatedAt);
    if (currentTime - checkTime.getTime() > 15 * 60 * 1000) {
      await prisma.otp.update({
        where: {
          userId,
        },
        data: {
          status: Constants.INACTIVE,
        },
      });
      return Helper.errorMsg(res, Constants.OTP_EXPIRED, 200);
    }
    const result = await prisma.otp.update({
      where: {
        userId,
      },
      data: {
        status: Constants.INACTIVE,
      },
    });
    if (!result) return Helper.errorMsg(res, Constants.INVALID_OTP, 200);
    await prisma.user.update({
      where: { id: result.userId },
      data: { password: hashedPassword },
    });
    return Helper.successMsg(res, Constants.PASSWORD_CHANGED, {});
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};
export const logout = async (req, res) => {
  try {
    await prisma.user.update({
      where: {
        id: req.user.id,
      },
      data: {
        deviceToken: null,
        online: false,
      },
    });
    return Helper.successMsg(res, Constants.LOGOUT, {});
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};
export const refreshToken = async (req, res) => {
  try {
    const authHeader = req.header("Authorization");

    if (!authHeader || !authHeader.startsWith("Bearer "))
      return Helper.errorMsg(res, Constants.INVALID_TOKEN, 401);
    const token = authHeader.split(" ")[1];

    const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
    const currentTime = Math.floor(Date.now() / 1000);
    if (decodedToken.exp < currentTime) {
      return Helper.errorMsg(res, "Token expired please login", 200);
    }
    console.log(decodedToken);
    return;
    const newToken = Helper.authUser(
      {
        id: decodedToken.id,
        email: decodedToken.email,
      },
      "15d"
    );
    const refreshToken = Helper.authUser(
      {
        id: decodedToken.id,
        email: decodedToken.email,
      },
      "30d"
    );
    return Helper.successMsg(res, "Token generated", {
      token: newToken,
      refreshToken,
    });
  } catch (err) {
    return Helper.catchBlock(req, res, null, err);
  }
};
