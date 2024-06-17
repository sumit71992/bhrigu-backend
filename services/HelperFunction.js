import joi from "joi";
import jwt from "jsonwebtoken";
import Sib from "sib-api-v3-sdk";
import twilio from "twilio";
import moment from "moment";
import Stripe from "stripe";
import { Constants } from "./Constants.js";
import { Logs } from "../middleware/log.js";
import * as validatePost from "../services/SchemaValidate/homeSchema.js";
import { prisma } from "../app.js";
import axios from "axios"

export const authUser = (obj,expireTime) => {
  return jwt.sign(obj, process.env.JWT_SECRET, {
    expiresIn: expireTime,
    algorithm: "HS256",
  });
};

export const validateRequest = (schema, value, res) => {
  const { error } = schema.validate(value, { abortEarly: false });

  if (error) {
    const result = error.details.map((err) => {
      const errorMessage = err.message.replace(/["]/g, "");
      return `${errorMessage}`;
    });
    return res.status(400).json({ error: result });
  }
};
export const successMsg = (res, message, obj) => {
  return res.status(200).json({ status: true, message: message, data: obj });
};
export const warningMsg = (res, message) => {
  return res.status(200).json({ status: false, message: message });
};
export const errorMsg = (res, message, code, err) => {
  if (err && err instanceof jwt.JsonWebTokenError) {
    return res.status(code).json({ status: false, message: "Invalid token" });
  }
  res.status(code).json({ status: false, message: message });
};
export const ObjectIdRequired = () => {
  return joi.string().hex().length(24).required();
};
export const ObjectIdOptional = () => {
  return joi.string().hex().length(24);
};
export const generateOTP = () => {
  const otp = Math.floor(1000 + Math.random() * 9000);
  return otp.toString();
};
export const generate6OTP = () => {
  const otp = Math.floor(100000 + Math.random() * 900000);
  return otp.toString();
};
export const extractUrls = (text) => {
  const urlRegex = /(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w.-]*)*\/?/gi;
  const urls = text.match(urlRegex);
  if (urls) {
    return urls.map((url) => {
      if (!/^https?:\/\//i.test(url)) {
        return "http://" + url;
      }
      return url;
    });
  }
  return [];
};

export const sendEmail = async (email, template, subject) => {
  try {
    const client = Sib.ApiClient.instance;
    var apiKey = client.authentications["api-key"];
    apiKey.apiKey = process.env.EMAIL_API_KEY;

    const tranEmailApi = new Sib.TransactionalEmailsApi();
    const sender = {
      email: "chefwire@chefwire.com",
      name: "ChefWire",
    };
    const receivers = [
      {
        email: email,
      },
    ];
    await tranEmailApi.sendTransacEmail({
      sender,
      to: receivers,
      subject: subject,
      htmlContent: template,
    });
    return true;
  } catch (err) {
    console.error(err);
    return null;
  }
};
export const sendMessage = async (number, body) => {
  const client = twilio(
    process.env.TWILIO_ACCOUNT_SID,
    process.env.TWILIO_AUTH_TOKEN
  );
  try {
    console.log(number);
    await client.messages.create({
      body: body,
      from: "+12055390892",
      to: number,
    });
    return true;
  } catch (error) {
    console.error(error);
    return null;
  }
};
export const HowManyOrderByUser = async (userId) => {
  try {
    const startOfToday = new Date();
    startOfToday.setHours(0, 0, 0, 0);
    const endOfToday = new Date();
    endOfToday.setHours(23, 59, 59, 999);
    const orders = await Order.find({
      userId,
      status: "COMPLETED",
      createdAt: { $gte: startOfToday, $lte: endOfToday },
    });
    console.log(orders);
    return orders.length;
  } catch (error) {
    console.error(error);
    return null;
  }
};
export const updateQuestUsers = async (
  req,
  totalOrders,
  completedOrders,
  quest
) => {
  try {
    const today = new Date();
    const expirationDate = new Date(today);
    expirationDate.setDate(expirationDate.getDate() + 5);
    expirationDate.setHours(23, 59, 0, 0);
    const expirationTime = new Date(today.getTime() + 24 * 60 * 60 * 1000);
    const completedIds = quest.completedUsers.map((usr) =>
      usr?.userId?.toString()
    );
    const startedIds = quest.startedUsers.map((usr) => usr?.userId?.toString());

    if (completedOrders === totalOrders) {
      if (completedIds.includes(req.user._id.toString())) {
        const expireTime = quest.startedUsers.find(
          (item) => item.userId.toString() === req.user._id.toString()
        )?.expireTime;
        if (expireTime && isExpired(expireTime)) {
          await Promise.all([
            Quest.findByIdAndUpdate(quest._id, {
              $pull: { completedUsers: { userId: req.user._id } },
            }),
            Quest.findByIdAndUpdate(quest._id, {
              $addToSet: { excludedUsers: req.user._id },
            }),
            Coupon.findByIdAndUpdate(quest.couponId, {
              $pull: { eligibleUsers: { userId: req.user._id } },
            }),
          ]);
        } else {
          return true;
        }
      } else {
        await Promise.all([
          Quest.findByIdAndUpdate(quest._id, {
            $addToSet: {
              completedUsers: {
                userId: req.user._id,
                expireTime: expirationDate,
              },
            },
          }),
          Coupon.findByIdAndUpdate(quest.couponId, {
            $addToSet: {
              eligibleUsers: {
                userId: req.user._id,
                expireTime: expirationDate,
              },
            },
          }),
        ]);
        return true;
      }
    }
    if (completedOrders > 0 && completedOrders < totalOrders) {
      if (startedIds.includes(req.user._id.toString())) {
        const expireTime = quest.startedUsers.find(
          (item) => item.userId.toString() === req.user._id.toString()
        )?.expireTime;
        if (expireTime && isExpired(expireTime)) {
          await Promise.all([
            Quest.findByIdAndUpdate(quest._id, {
              $pull: { startedUsers: { userId: req.user._id } },
            }),
            Quest.findByIdAndUpdate(quest._id, {
              $addToSet: { excludedUsers: req.user._id },
            }),
          ]);
        } else {
          return true;
        }
      } else {
        await Quest.findByIdAndUpdate(quest._id, {
          $addToSet: {
            startedUsers: { userId: req.user._id, expireTime: expirationTime },
          },
        });
        return true;
      }
    }
  } catch (error) {
    console.error(error);
    return null;
  }
};
export const extractHashtags = (sentence) => {
  const regex = /#\w+/g;
  const hashtags = sentence.match(regex);
  return hashtags || [];
};
export const Sender = (req) => {
  return {
    _id: req.user._id,
    name: req.user.name,
    profilePic: req.user.profilePic,
  };
};
export const generateOrderId = () => {
  const randomNumber = Math.floor(Math.random() * 900000) + 100000;
  return "ORDR" + randomNumber.toString();
};

export const catchBlock = (req, res, next, err) => {
  if (err.name === "TokenExpiredError") {
    Logs(req, "TokenExpiredError", next);
    return errorMsg(res, "Please login again your token has been expired", 200);
  }
  if (
    err.message === Constants.INVALID_ID ||
    err.message === Constants.SOMETHINGWRONG ||
    err.message === "Suggested Product ID is invalid" ||
    err.message === Constants.DATA_NOT_CREATED
  ) {
    return errorMsg(res, err.message, 200);
  }
  console.log(err);
  next && Logs(req, Constants.SOMETHING_WRONG, next);
  return errorMsg(res, Constants.SOMETHING_WRONG, 500);
};
export const validateCartItems = async (items) => {
  try {
    let totalPrice = 0;

    // Iterate over each item in the cart
    for (const item of items) {
      const restaurantMenu = await RestaurantMenu.findById(
        item.restaurantMenuId
      );

      // If restaurantMenu doesn't exist or item doesn't have price details, skip validation
      if (
        !restaurantMenu ||
        !restaurantMenu.price ||
        restaurantMenu.price.length === 0
      ) {
        return {
          status: false,
          message: `Menu item with ID ${item.restaurantMenuId} does not exist or has no price details.`,
        };
      }

      // Iterate over each price detail in the restaurantMenu
      for (const priceDetail of item.price) {
        const matchedPriceDetail = restaurantMenu.price.find((p) => {
          return p._id.toString() === priceDetail.sizeId;
        });

        // If sizeId from cart item doesn't match any sizeId in restaurantMenu, skip validation
        if (!matchedPriceDetail) {
          return {
            status: false,
            message: `Size ID ${priceDetail._id} not found for menu item with ID ${item.restaurantMenuId}.`,
          };
        }
        // Check if unitPrice matches the price stored in restaurantMenu
        if (matchedPriceDetail.price !== priceDetail.unitPrice) {
          return {
            status: false,
            message: `Unit price mismatch for size ID ${priceDetail.sizeId} of menu item.`,
          };
        }
        totalPrice += priceDetail.unitPrice * priceDetail.quantity;
      }
    }

    return {
      status: true,
      totalPrice,
    };
  } catch (error) {
    throw new Error(`Error validating cart items: ${error.message}`);
  }
};
export const isExpired = (expireTime) => {
  return new Date(expireTime) < new Date();
};
export const getSlots = (res, obj) => {
  if (validateRequest(validatePost.subSchedule, obj, res)) return;
  const slots = [];
  let currentTime = moment(obj.startTime, "HH:mm");
  const end = moment(obj.endTime, "HH:mm");
  while (currentTime.isBefore(end)) {
    const nextTime = currentTime.clone().add(obj.interval, "minutes");
    const slotEndTime = nextTime.isAfter(end) ? end : nextTime;
    const slot = {
      startTime: currentTime.format("HH:mm"),
      endTime: slotEndTime.format("HH:mm"),
      booked: 0,
      isDisabled: false,
    };
    slots.push(slot);
    currentTime = nextTime;
  }
  return slots;
};
export const capitalizeEveryWord = (sentence) => {
  const words = sentence?.split(" ");
  const capitalizedWords = words?.map((word) => {
    return word?.charAt(0)?.toUpperCase() + word?.slice(1);
  });
  const capitalizedSentence = capitalizedWords?.join(" ");
  return capitalizedSentence;
};
export const fillMissingMonths = (data) => {
  const result = [];
  const currentDate = new Date();
  for (let i = 11; i >= 0; i--) {
    const date = new Date(
      currentDate.getFullYear(),
      currentDate.getMonth() - i,
      1
    );
    const month = date.toLocaleString("default", { month: "short" });
    const year = date.getFullYear().toString();

    const existingData = data.find(
      (d) =>
        d._id.month === date.getMonth() + 1 && d._id.year === date.getFullYear()
    );
    result.push({
      month,
      year,
      count: existingData ? existingData.count : 0,
    });
  }

  return result;
};
export const fillMissingDays = (data, days) => {
  const result = [];
  const currentDate = new Date();
  for (let i = days; i >= 0; i--) {
    // Iterate over the past 30 days
    const date = new Date(currentDate.getTime() - i * 24 * 60 * 60 * 1000); // Calculate the date
    const month = date.toLocaleString("default", { month: "short" });
    const day = date.getDate().toString();

    const existingData = data.find(
      (d) =>
        d._id.day === date.getDate() &&
        d._id.month === date.getMonth() + 1 &&
        d._id.year === date.getFullYear()
    );

    result.push({
      month,
      day,
      count: existingData ? existingData.count : 0,
    });
  }

  return result;
};
// export const distanceQuery = `
// SELECT
//   id,
//   storeName,
//   description,
//   location,
//   (
//     6371 * acos(
//       cos(radians(${userLatitude})) *
//       cos(radians(JSON_EXTRACT(location, '$.lat'))) *
//       cos(radians(JSON_EXTRACT(location, '$.long')) - radians(${userLongitude})) +
//       sin(radians(${userLatitude})) *
//       sin(radians(JSON_EXTRACT(location, '$.lat')))
//     )
//   ) AS distance
// FROM
//   Vendor
// HAVING
//   distance < 100 -- Optional: Filter vendors within 100 km
// ORDER BY
//   distance;
// `;
export const validate24HrsTime = joi
  .string()
  .pattern(/^([01]\d|2[0-3]):([0-5]\d)$/);

export const handlePayment = async (req, promote, autoRenew) => {
  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
  try {
    let customer;
    const userEmail = req.user.email;
    const auth0UserId = req.user.id;
    const promotionId = promote.id;
    const priceId =
      promote.days === 7
        ? process.env.DAYS7
        : promote.days === 30
        ? process.env.DAYS30
        : process.env.DAYS5;
    const lineItems = [{ price: priceId, quantity: 1 }];
    const existingCustomers = await stripe.customers.list({
      email: userEmail,
      limit: 1,
    });
    if (autoRenew) {
      if (existingCustomers.data.length > 0) {
        // Customer already exists
        customer = existingCustomers.data[0];

        // Check if the customer already has an active subscription
        const subscriptions = await stripe.subscriptions.list({
          customer: customer.id,
          status: "active",
          limit: 1,
        });

        if (subscriptions.data.length > 0) {
          // Customer already has an active5 subscription, send them to biiling portal to manage subscription
          const stripeSession = await stripe.billingPortal.sessions.create({
            customer: customer.id,
            return_url:
              "https://billing.stripe.com/p/login/test_bIY2aIdpccPD0qAcMM",
          });
          return res.status(409).json({ redirectUrl: stripeSession.url });
        }
      } else {
        // No customer found, create a new one
        customer = await stripe.customers.create({
          email: userEmail,
          metadata: {
            userId: auth0UserId,
          },
        });
      }
      console.log(22222);
      // Create a subscription
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: lineItems,
        mode: "subscription",
        billing_address_collection: "auto",
        success_url:
          "http://localhost:3000/success?sessionId={CHECKOUT_SESSION_ID}",
        cancel_url: "http://localhost:3000/cancel",
        metadata: {
          userId: auth0UserId,
        },
        customer: customer.id,
      });
      return session;
    } else {
      // Create a one-time payment
      console.log(11111);

      if (existingCustomers.data.length > 0) {
        customer = existingCustomers.data[0];
      } else {
        customer = await stripe.customers.create({
          email: userEmail,
          metadata: {
            userId: auth0UserId,
          },
        });
      }
      const lineItems = [
        {
          price_data: {
            currency: "inr",
            product_data: {
              name: promote.days,
            },
            unit_amount: promote.price * 100,
          },
          quantity: 1,
        },
      ];
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: lineItems,
        mode: "payment",
        billing_address_collection: "auto",
        success_url:
          "http://localhost:3000/success?sessionId={CHECKOUT_SESSION_ID}",
        cancel_url: "http://localhost:3000/cancel",
        metadata: {
          userId: auth0UserId,
        },
        customer: customer.id,
      });
      return session;
    }
  } catch (error) {
    console.error("Error processing payment:", error);
    throw new Error("Payment processing failed");
  }
};
export const parseFormData = (req) => {
  for (const key in req.body) {
    try {
      if (req.body[key] === "true") {
        req.body[key] = true;
      } else if (req.body[key] === "false") {
        req.body[key] = false;
      } else if (!isNaN(req.body[key])) {
        req.body[key] = parseFloat(req.body[key]);
      } else {
        req.body[key] = JSON.parse(req.body[key]);
      }
    } catch (e) {
      req.body[key] = req.body[key];
    }
  }
  return req.body;
};
export const parseQueryData = (req) => {
  for (const key in req.query) {
    try {
      if (req.query[key] === "true") {
        req.query[key] = true;
      } else if (req.query[key] === "false") {
        req.query[key] = false;
      } else if (!isNaN(req.query[key])) {
        req.query[key] = parseFloat(req.query[key]);
      } else {
        req.query[key] = JSON.parse(req.query[key]);
      }
    } catch (e) {
      req.query[key] = req.query[key];
    }
  }
  return req.query;
};
export const checkProductAvailability = async (
  startDate,
  endDate,
  products
) => {
  const startISODate = new Date(startDate).toISOString();
  const endISODate = new Date(endDate).toISOString();
  let unavailableDates = [];

  // Iterate over each product and check availability
  for (const product of products) {
    const result = await prisma.productAvailability.findMany({
      where: {
        productId: product.id,
        date: {
          gte: startISODate,
          lte: endISODate,
        },
        availableQuantity: {
          lt: product.quantity,
        },
      },
      select: {
        date: true,
        availableQuantity: true,
      },
    });

    if (result.length > 0) {
      unavailableDates = unavailableDates.concat(
        result.map((record) => moment(record.date).format("YYYY-MM-DD"))
      );
    }
  }
  return [...new Set(unavailableDates)];
};
export const updateProductAvailability = async (
  startDate,
  endDate,
  product,
  quantity
) => {
  console.log(product);
  const dates = getDatesInRange(startDate, endDate);
  const prodAvail = await prisma.productAvailability.findFirst({
    where: { productId: product.id },
  });
  try {
    console.log(123,prodAvail)
    if (prodAvail) {
      const prodAvailUpdate = await prisma.productAvailability.updateMany({
        where: {
          productId: product.id,
        },
        data: {
          totalQuantity: product.totalQuantity,
          availableQuantity: {
            increment: product.totalQuantity - prodAvail?.totalQuantity,
          },
        },
      });
    }

    for (const date of dates) {
      await prisma.productAvailability.upsert({
        where: {
          productId_date: {
            productId: product.id,
            date: new Date(date).toISOString(),
          },
        },
        update: {
          availableQuantity: {
            decrement: quantity,
          },
        },
        create: {
          productId: product.id,
          date: new Date(date).toISOString(),
          totalQuantity: product.totalQuantity,
          availableQuantity: product.totalQuantity - quantity,
        },
      });
    }
    return true;
  } catch (err) {
    console.log("updateProductAvailabilityError", err);
    return null;
  }
};
export const getDatesInRange = (startDate, endDate) => {
  let dates = [];
  let currentDate = moment(startDate);

  while (currentDate <= moment(endDate)) {
    dates.push(currentDate.format("YYYY-MM-DD"));
    currentDate = currentDate.add(1, "days");
  }
  return dates;
};
export const calculateDrivingDistance = async (origin, destination) => {
  try {
    const response = await axios.get(`https://router.project-osrm.org/route/v1/driving/${origin};${destination}`);

    if (response.data.code === 'Ok') {
      const distance = response.data.routes[0].distance / 1000; // Distance in kilometers
      return distance;
    } else {
      return null
    }
  } catch (error) {
    console.error('Error calculating driving distance:', error.message);
    throw error;
  }
};