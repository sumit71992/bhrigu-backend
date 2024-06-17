import Joi from "joi";
import joiDate from "@joi/date";
import { Constants } from "../Constants.js";

let joi = Joi.extend(joiDate);

export const categorySchema = joi.object({
  restaurantId: joi.string().hex().length(24),
  name: joi.string().min(2).max(100).required(),
  icon: joi.binary(),
});
export const updateCategorySchema = joi.object({
  id: joi.string().hex().length(24).required(),
  name: joi.string().min(2).max(100),
  icon: joi.string(),
});
export const updateOrderStatusSchema = joi.object({
  orderId: joi.string().hex().length(24).required(),
  status: joi
    .string()
    .valid(
      Constants.REJECTED,
      Constants.INPROGRESS,
      Constants.PENDING,
      Constants.COMPLETED
    )
    .required(),
});

export const privacySchema = joi.object({
  name: joi.string().required(),
  description: joi.string().required(),
  type: joi.string().valid("TERM", "PRIVACY").required(),
});
export const privacyGetSchema = joi.object({
  type: joi.string().valid("TERM", "PRIVACY").required(),
});
export const excelSchema = joi.object({
  name: joi
    .string()
    .required()
    .regex(/\.xlsx$/i),
  filename: joi.binary().required(),
});
export const globalSchema = joi.object({
  type: joi.string().valid("ACADEMIN").required(),
});

export const idSchema = joi.object({
  id: joi.string().hex().length(24).required(),
});
export const optionalIdSchema = joi.object({
  id: joi.string().hex().length(24),
});
export const offerSchema = joi.object({
  couponId: joi.string().hex().length(24).required(),
  typeId: joi.string().hex().length(24),
  type: joi
    .string()
    .valid("RESTAURANT", "DINEIN", "CATERER", "FOOD", "GLOBAL", "QUEST")
    .required(),
  category: joi
    .string()
    .valid("RESTAURANT", "DINEIN", "CATERER", "FOOD", "QUEST")
    .required(),
  name: joi.string().allow(""),
  banner: joi.binary().required(),
  validTill: joi.date(),
  users: joi.array(),
});
export const questSchema = joi.object({
  couponId: joi.string().hex().length(24).required(),
  questTitle: joi.string().required(),
  rules: joi.array().items(joi.string()),
  banner: joi.binary(),
  validTill: joi.date(),
});
export const getQuestSchema = joi.object({
  questId: joi.string().hex().length(24),
});
export const updateQuestSchema = joi.object({
  couponId: joi.string().hex().length(24),
  questTitle: joi.string(),
  rules: joi.array().items(joi.string()),
  validTill: joi.date(),
});
export const couponSchema = joi.object({
  code: joi.string().required(),
  discount: joi.number().required(),
  discountType: joi.string().valid("FLAT", "UPTO"),
  validTill: joi.date(),
  isGlobal: joi.boolean().strict(true),
  eligibleUsers: joi.array().items(
    joi.object({
      userId: joi.string().hex().length(24).required(),
      validTill: joi.date(),
    })
  ),
  excludedUsers: joi.array().items(joi.string().hex().length(24).required()),
});
export const menuSchema = joi.object({
  categoryId: joi.string().hex().length(24).required(),
  name: joi.string().required(),
  nutrition: joi.array().items(
    joi.object({
      name: joi.string().required(),
      value: joi.number().required(),
    })
  ),
  description: joi.string().required(),
  price: joi.array().items(
    joi.object({
      size: joi.string().required(),
      price: joi.number().required(),
    })
  ),
  profilePic: joi.binary().required(),
});
export const getMenuSchema = joi.object({
  categoryId: joi.string().hex().length(24),
  menuId: joi.string().hex().length(24),
  type: joi.string().valid("CATERING", "RESTAURANT").required(),
});
export const makeOrderSchema = joi.object({
  restaurantId: joi.string().hex().length(24).required(),
  addressId: joi.when("orderType", {
    is: Constants.DINEIN,
    then: joi.forbidden(),
    otherwise: joi.string().hex().length(24).required(),
  }),
  slotId: joi.when("orderType", {
    is: Constants.DINEIN,
    then: joi.string().hex().length(24).required(),
    otherwise: joi.forbidden(),
  }),
  dineInId: joi.when("orderType", {
    is: Constants.DINEIN,
    then: joi.string().hex().length(24).required(),
    otherwise: joi.forbidden(),
  }),
  couponId: joi.string().hex().length(24),
  orderType: joi.string().valid("CATERER", "DINEIN", "FOOD"),
  paymentMethod: joi.string(),
  items: joi.when("orderType", {
    is: Constants.CATERER,
    then: joi.array().items(joi.object({
      restaurantMenuId: joi.string().hex().length(24).required(),
    })).required(),
    otherwise: joi.when("orderType", {
      is: Constants.DINEIN,
      then: joi.forbidden(),
      otherwise: joi
        .array()
        .items(
          joi.object({
            restaurantMenuId: joi.string().hex().length(24).required(),
            price: joi.array().items(
              joi.object({
                sizeId: joi.string().hex().length(24).required(),
                size: joi.string().required(),
                unitPrice: joi.number().required(),
                quantity: joi.number().required(),
              })
            ),
          })
        )
        .required(),
    }),
  }),
  totalPrice: joi.when("orderType", {
    is: Constants.FOOD,
    then: joi.number().required(),
    otherwise: joi.forbidden(),
  }),
  eventName: joi.when("orderType", {
    is: Constants.CATERER,
    then: joi.string().required(),
    otherwise: joi.string().optional(),
  }),
  eventType: joi.when("orderType", {
    is: Constants.CATERER,
    then: joi.string().required(),
    otherwise: joi.string().optional(),
  }),
  eventDate: joi.when("orderType", {
    is: Constants.CATERER,
    then: joi.date().format("YYYY-MM-DD").required(),
    otherwise: joi.string().optional(),
  }),
  eventTime: joi.when("orderType", {
    is: Constants.CATERER,
    then: joi
      .string()
      .required()
      .regex(/^([01]\d|2[0-3]):([0-5]\d)$/)
      .message("The endTime must be in the format HH:mm (24-hour)"),
    otherwise: joi.string().optional(),
  }),
  noOfGuest: joi.when("orderType", {
    is: Constants.FOOD,
    then: joi.number().optional(),
    otherwise: joi.number().min(1).required(),
  }),
  description: joi.string(),
  tableType: joi.when("orderType", {
    is: Constants.DINEIN,
    then: joi.string().valid("BREAKFAST", "LUNCH", "DINNER").required(),
    otherwise: joi.forbidden(),
  }),
});
export const getOrderSchema = joi.object({
  orderId: joi.string().hex().length(24),
  type: joi.when("orderId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.string().valid("UPCOMING", "PAST").required(),
  }),
});
export const addCartSchema = joi.object({
  items: joi
    .array()
    .items(
      joi.object({
        restaurantMenuId: joi.string().hex().length(24).required(),
        price: joi.array().items(
          joi.object({
            sizeId: joi.string().hex().length(24).required(),
            size: joi.string().required(),
            unitPrice: joi.number().required(),
            quantity: joi.number().required(),
          })
        ),
      })
    )
    .required(),
});
export const QnaSchema = joi.object({
  question: joi.string().required(),
  answer: joi.string().required(),
});
export const updateQnaSchema = joi.object({
  qnaId: joi.string().hex().length(24).required(),
  question: joi.string().required(),
  answer: joi.string().required(),
  status: joi.string().valid(Constants.ACTIVE, Constants.INACTIVE),
});
export const updateQnaOrderSchema = joi.array().items(
  joi.object({
    qnaId: joi.string().hex().length(24).required(),
    order: joi.number().required(),
  })
);
export const getQnaSchema = joi.object({
  qnaId: joi.string().hex().length(24),
  restaurantId: joi.string().hex().length(24),
  type: joi.string(),
});
export const feedBackSchema = joi.object({
  restaurantId: joi.string().hex().length(24).required(),
  orderId: joi.string().required(),
  rating: joi.number().required(),
  reviewText: joi.string(),
});
export const tableSchema = joi.object({
  tableCount: joi.number().required(),
  seatingCapacity: joi.number().required(),
});
export const subSchedule = joi.object({
  startTime: joi
    .string()
    .required()
    .regex(/^([01]\d|2[0-3]):([0-5]\d)$/)
    .message("The startTime must be in the format HH:mm (24-hour)"),
  endTime: joi
    .string()
    .required()
    .regex(/^([01]\d|2[0-3]):([0-5]\d)$/)
    .message("The endTime must be in the format HH:mm (24-hour)"),
  interval: joi.number().required(),
});
export const tableScheduleSchema = joi.object({
  breakFastSchedule: subSchedule,
  lunchSchedule: subSchedule,
  dinnerSchedule: subSchedule,
  tableCount: joi.number().required(),
  seatingCapacity: joi.number().required(),
});

export const tableSlotSchema = joi.object({
  startDate: joi.date().format("YYYY-MM-DD").required(),
  endDate: joi.date().format("YYYY-MM-DD"),
});
export const getSlotchema = joi.object({
  restaurantId: joi.string().hex().length(24).required(),
  date: joi.date().format("YYYY-MM-DD").required(),
});
export const bookSlotchema = joi.object({
  restaurantId: joi.string().hex().length(24).required(),
  slotId: joi.string().hex().length(24).required(),
});
export const updateTableCountSchema = joi.object({
  slotId: joi.string().hex().length(24).required(),
  count: joi.number().required(),
});
export const planSchema = joi.object({
  name: joi.string().valid("FREE", "GOLD", "PLATINUM").required(),
  price: joi.number(),
  features: joi.array().items(joi.string().required()),
});
