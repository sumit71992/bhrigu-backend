import jwt from "jsonwebtoken";
import * as Helper from "../services/HelperFunction.js";
import { Constants } from "../services/Constants.js";
import { prisma } from "../app.js";
import { getUser } from "../services/userService.js";

export const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.header("Authorization");
    const deviceToken = req.header("deviceToken");

    if (!authHeader || !authHeader.startsWith("Bearer "))
      return Helper.errorMsg(res, Constants.INVALID_TOKEN, 401);
    const token = authHeader.split(" ")[1];
    const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
    const currentTime = Math.floor(Date.now() / 1000);
    if (decodedToken.exp < currentTime) {
      return Helper.errorMsg(res,"Token expired",200);
    }

    const usr = await getUser(decodedToken.id, null, null, null, true);
    if (!usr) {
      return Helper.errorMsg(res, Constants.WRONG_EMAIL, 401);
    }
    if (usr.status === Constants.INACTIVE) {
      return Helper.errorMsg(res, Constants.BLOCKED, 401);
    }
    if (deviceToken && deviceToken !== usr.deviceToken) {
      await prisma.user.update({
        where: {
          id: usr.id,
        },
        data: { deviceToken },
      });
    }
    req.user = usr;
    next();
  } catch (err) {
    Helper.catchBlock(req, res, null, err);
  }
};

// export const adminRoute = async (req, res, next) => {
//   try {
//     const url = req.url.split("?")[0];
//     const permission = req.user.role.permissions;
//     if (req.user.role !== "admin") {
//       return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//     }
//     switch (url) {
//       case "/get-reports":
//         if (!permission.Report.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-user-profile":
//       case "/get-user-list":
//         if (!permission.User.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/block-unblock-user":
//         if (!permission.User.delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-posts":
//         if (!permission.Post.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/delete-post":
//         if (!permission.Post.delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-comments":
//         if (!permission.Comment.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/delete-comment":
//         if (!permission.Comment.delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-groups":
//         if (!permission.Group.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/delete-group":
//         if (!permission.Group.delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-projects":
//         if (!permission["My Passion Project"].view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/delete-project":
//         if (!permission["My Passion Project"].delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-role":
//         if (!permission.Role.view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/update-role":
//         if (!permission.Role.edit) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/delete-role":
//         if (!permission.Role.delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/add-user":
//         if (!permission["Organization User"].add) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/update-org-user":
//         if (!permission["Organization User"].edit) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/get-org-user-list":
//         if (!permission["Organization User"].view) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//       case "/block-unblock-org-user":
//         if (!permission["Organization User"].delete) {
//           return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//         }
//         break;
//     }
//     next();
//   } catch (err) {
//     return Helper.errorMsg(res, Constants.INVALID_TOKEN, 500, err);
//   }
// };
// export const merchantRoute = async (req, res, next) => {
//   try {
//     if (req.user.role !== "merchant") {
//       return Helper.errorMsg(res, Constants.NOT_AUTHORIZED, 200);
//     }
//     next();
//   } catch (err) {
//     return Helper.errorMsg(res, Constants.INVALID_TOKEN, 500, err);
//   }
// };
