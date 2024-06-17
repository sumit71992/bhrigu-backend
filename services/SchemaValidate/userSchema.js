import Joi from "joi";
import joiDate from "@joi/date";
import { Constants } from "../Constants.js";
import { validate24HrsTime } from "../HelperFunction.js";

let joi = Joi.extend(joiDate);
const passwordPattern =
  /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+[\]{};':"\\|,.<>/?]).{8,50}$/;
export const passwordSchema = joi
  .string()
  .pattern(passwordPattern)
  .messages({
    "string.pattern.base":
      "Password must contain at least one capital letter, one number, and one special character.",
  })
  .min(6)
  .max(50)
  .required();
export const passwordSchemaOptional = joi
  .string()
  .pattern(passwordPattern)
  .messages({
    "string.pattern.base":
      "Password must contain at least one capital letter, one number, and one special character.",
  })
  .min(6)
  .max(50);
export const signupSchema = joi.object({
  name: joi.string().required(),
  email: joi.string().email().required(),
  mobileNumber: joi.number().required(),
  password: passwordSchema,
});
export const username = joi.object({
  userName: joi.string().required(),
});
export const vendorSignupSchema = joi.object({
  storeName: joi.string().required(),
  description: joi.string().required(),
  isContactVisible: joi.boolean().required(),
  isAddressVisible: joi.boolean().required(),
  email: joi.string().email().required(),
  mobileNumber: joi.string().min(6).max(15).required(),
  street: joi.string().required(),
  zipCode: joi.string().required(),
  city: joi.string().required(),
  state: joi.string().required(),
  country: joi.string().required(),
  lat: joi.number().required(),
  lng: joi.number().required(),
  storeHours: joi
    .object({
      monday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      tuesday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      wednesday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      thursday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      friday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      saturday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      sunday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
    })
    .required(),
  social: joi.object({
    youtube: joi.string(),
    facebook: joi.string(),
    instagram: joi.string(),
    x: joi.string(),
    imdb: joi.string(),
    tiktok: joi.string(),
    vimeo: joi.string(),
  }),
  bussinessName: joi.string().required(),
  bussinessIdNumber: joi.string().required(),
  businessState: joi.string().required(),
  socialsecurityNumber: joi.string(),
  profilePic: joi.binary().allow("", null),
  bannerPic: joi.array().items(joi.binary()).required(),
});
export const updateVendorSchema = joi.object({
  storeName: joi.string().required(),
  description: joi.string().required(),
  isContactVisible: joi.boolean().required(),
  isAddressVisible: joi.boolean().required(),
  email: joi.string().email().required(),
  mobileNumber: joi.string().min(6).max(15).required(),
  street: joi.string().required(),
  zipCode: joi.string().required(),
  city: joi.string().required(),
  state: joi.string().required(),
  country: joi.string().required(),
  storeHours: joi
    .object({
      monday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      tuesday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      wednesday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      thursday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      friday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      saturday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
      sunday: joi
        .object({
          open: validate24HrsTime.allow(null),
          close: validate24HrsTime.allow(null),
        })
        .required(),
    })
    .required(),
  social: joi.object({
    youtube: joi.string(),
    facebook: joi.string(),
    instagram: joi.string(),
    x: joi.string(),
    imdb: joi.string(),
    tiktok: joi.string(),
    vimeo: joi.string(),
  }),
  bussinessName: joi.string().required(),
  bussinessIdNumber: joi.string(),
  businessState: joi.string().required(),
  socialsecurityNumber: joi.string(),
  profilePic: joi.binary().allow("", null),
  bannerPic: joi.array().items(joi.binary()),
  amenties: joi.array().items(
    joi.object({
      id: joi.number().required(),
      description: joi.string().allow("").required(),
      images: joi.array().items(joi.string().allow("")).required(),
      status: joi.boolean().required(),
    })
  ),
  studioPic: joi.array().items(joi.binary()),
  prepPic: joi.array().items(joi.binary()),
  searchEngineVisible: joi.boolean().required(),
  status: joi.string().valid("ACTIVE", "INACTIVE").required(),
  bannerImagesToDelete: joi.array().items(joi.string().required()),
  vacationDates: joi.array().items(joi.date().format("YYYY-MM-DD").required()),
  promotion: joi.object({
    promotionId: joi.number().required(),
    autoRenew: joi.boolean().required(),
  }),
});

export const promotionSchema = joi.object({
  name: joi.string().required(),
  price: joi.number().strict(true).required(),
  days: joi.number().strict(true).required(),
  description: joi.string(),
});
export const loginSchema = joi.object({
  email: joi.string().email().required(),
  password: joi.string().max(50).required(),
});

export const otpSchema = joi.object({
  email: joi.when("user_id", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.string().email().required(),
  }),
  userId: joi.string(),
  otp: joi.string().min(4).max(6).required(),
  type: joi.string().valid("SIGNUP", "FORGOT", "SIGNUPVERIFY").required(),
});
export const verifyOtpSchema = joi.object({
  email: joi.when("user_id", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.string().email().required(),
  }),
  otp: joi.string().min(4).max(4).required(),
});
export const resetSchema = joi.object({
  userId: joi.string().required(),
  otp: joi.string().required(),
  password: passwordSchema,
});
export const changePasswordSchema = joi.object({
  oldPassword: passwordSchema,
  newPassword: passwordSchema,
});
export const emailSchema = joi.object({
  email: joi.string().email().required(),
});
export const userIdSchema = joi.object({
  userId: joi.string().required(),
});
export const userIdSchemaOptional = joi.object({
  userId: joi.string(),
});
export const chatIdSchema = joi.object({
  chatId: joi.string().required(),
});
export const updateUnreadMsgSchema = joi.object({
  chatId: joi.string().required(),
  reset: joi.boolean().strict(true).required(),
});
export const nameSchema = joi.object({
  name: joi.string().required(),
});
export const updateUnreadNotiSchema = joi.object({
  minus: joi.boolean().strict(true),
  reset: joi.boolean().strict(true),
});
export const getMessagesSchema = joi.object({
  chatId: joi.string().required(),
  page: joi.string(),
});
export const deleteChatSchema = joi.object({
  chatId: joi.string().required(),
  type: joi.string().valid("DELETE", "EXIT").required(),
});
export const chatSchema = joi.object({
  chatId: joi.string().required(),
  messageText: joi.when("messageFile", {
    is: joi.exist(),
    then: joi.optional(),
    otherwise: joi.string().min(1).required(),
  }),
  messageFile: joi.binary(),
});
export const updateUserSchema = joi.object({
  profilePic: joi.binary(),
  firstName: joi.string().required(),
  middleName: joi.string(),
  lastName: joi.string().required(),
  mobileNumber: joi
    .string()
    .pattern(/^\+\d{1,3}-\d{6,14}$/)
    .messages({
      "string.pattern.base":
        "Mobile number must be in the format +<country_code>-<6 to 14 digit_number>",
    }),
  email: joi.string().email().required(),
  userName: joi.string().required(),
  oldPassword: passwordSchemaOptional,
  newPassword: joi.when("oldPassword", {
    is: joi.exist(),
    then: passwordSchema,
    otherwise: joi.forbidden(),
  }),
  social: joi
    .object({
      youtube: joi.string(),
      facebook: joi.string(),
      instagram: joi.string(),
      x: joi.string(),
      imdb: joi.string(),
      tiktok: joi.string(),
      vimeo: joi.string(),
    })
    .required(),
  searchEngineVisible: joi.boolean(),
  searchEngineAndGearGhostVisible: joi.boolean(),
});

export const idSchema = joi.object({
  id: joi.number().required(),
});
export const idOptionalSchema = joi.object({
  id: joi.number(),
});
export const inventorySchema = joi.object({
  title: joi.string().required(),
  quantity: joi.number().strict(true).required(),
  categoryId: joi.number().required(),
});
export const feeAndChargeSchema = joi.object({
  items: joi
    .array()
    .items(
      joi.object({
        chargeType: joi.string().required(),
        amount: joi.number().strict(true).required(),
      })
    )
    .required(),
});
export const getPrivacyTermsSchema = joi.object({
  type: joi.string().valid("PRIVACY", "TERMS", "COMMUNITY").required(),
});
export const supportSchema = joi.object({
  message: joi.string().required(),
});
export const productSchema = joi.object({
  title: joi.string().required(),
  sellPrice: joi.number().strict(true).when("forSale", {
    is: true,
    then: joi.required(),
    otherwise: joi.forbidden(),
  }),
  dailyRentalPrice: joi.number().strict(true).when("forRent", {
    is: true,
    then: joi.required(),
    otherwise: joi.forbidden(),
  }),
  totalQuantity: joi.number().strict(true).required(),
  description: joi.string().required(),
  media: joi.array().items(joi.binary().required()).required(),
  primaryImageIndex: joi.number().strict(),
  visibility: joi
    .string()
    .valid("PRIVATE", "PUBLIC", "DRAFT", "CLOSED")
    .required(),
  forSale: joi.boolean().strict(true).required(),
  forRent: joi.boolean().strict(true).required(),
  categoryId: joi.number(),
  categoryName: joi.string().when("categoryId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  subCategoryId: joi.number(),
  subCategoryName: joi.string().when("subCategoryId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  brandId: joi.number(),
  brandName: joi.string().when("brandId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  modelId: joi.number(),
  modelName: joi.string().when("modelId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  rapidBook: joi.boolean().strict().required(),
  disableSameDayRental: joi.boolean().strict().required(),
  promotion: joi.object({
    promotionId: joi.number().required(),
    autoRenew: joi.boolean().required(),
  }),
  replaceMentPrice: joi.number().strict(true).required(),
  suggestedProduct: joi
    .array()
    .items(joi.object({ id: joi.string().required() }).optional()),
  includedKit: joi.array().items(
    joi
      .object({
        includedKitId: joi.number().required(),
        inventory: joi
          .array()
          .items(
            joi
              .object({
                inventoryId: joi.number().required(),
                quantity: joi.number().strict(true).required(),
              })
              .required()
          )
          .required(),
      })
      .optional()
  ),
});
export const updateProductSchema = joi.object({
  id: joi.number().required(),
  title: joi.string().required(),
  sellPrice: joi.number().strict(true).when("forSale", {
    is: true,
    then: joi.required(),
    otherwise: joi.forbidden(),
  }),
  dailyRentalPrice: joi.number().strict(true).when("forRent", {
    is: true,
    then: joi.required(),
    otherwise: joi.forbidden(),
  }),
  totalQuantity: joi.number().strict(true).min(0).required(),
  description: joi.string().required(),
  mediaToDelete: joi.array().items(joi.string().optional()),
  media: joi.array().items(joi.binary().optional()),
  primaryImageIndex: joi.number().strict(),
  visibility: joi
    .string()
    .valid("PRIVATE", "PUBLIC", "DRAFT", "CLOSED")
    .required(),
  forSale: joi.boolean().strict(true).required(),
  forRent: joi.boolean().strict(true).required(),
  categoryId: joi.number(),
  categoryName: joi.string().when("categoryId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  subCategoryId: joi.number(),
  subCategoryName: joi.string().when("subCategoryId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  brandId: joi.number(),
  brandName: joi.string().when("brandId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  modelId: joi.number(),
  modelName: joi.string().when("modelId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.required(),
  }),
  rapidBook: joi.boolean().strict().required(),
  disableSameDayRental: joi.boolean().strict().required(),
  promotion: joi.object({
    promotionId: joi.number().required(),
    autoRenew: joi.boolean().required(),
  }),
  replaceMentPrice: joi.number().strict(true).required(),
  suggestedProduct: joi
    .array()
    .items(joi.object({ id: joi.number().required() }).optional()),
  includedKit: joi.array().items(
    joi
      .object({
        includedKitId: joi.number().required(),
        status: joi.boolean().strict().required(),
        inventory: joi
          .array()
          .items(
            joi
              .object({
                inventoryId: joi.number().required(),
                quantity: joi.number().strict(true).required(),
              })
              .required()
          )
          .required(),
      })
      .optional()
  ),
});
export const getProductSchema = joi.object({
  filter: joi.object({
    startPrice: joi.number().allow(null),
    endPrice: joi.number().when("startPrice", {
      is: joi.exist(),
      then: joi.required(),
      otherwise: joi.optional().allow(null),
    }),
    rent: joi.string().valid("true", "false").allow(null),
    sale: joi.string().valid("true", "false").allow(null),
    city: joi.string().allow(null),
    state: joi.string().when("city", {
      is: joi.string(),
      then: joi.required(),
      otherwise: joi.allow(null),
    }),
    startDate: joi.date().format("YYYY-MM-DD").allow(null),
    endDate: joi
      .date()
      .format("YYYY-MM-DD")
      .when("startDate", {
        is: joi.date().format("YYYY-MM-DD"),
        then: joi.required(),
        otherwise: joi.allow(null),
      }),
    sort: joi
      .string()
      .valid("popularity", "newest", "oldest", "price-asc", "price-desc")
      .when("productId", {
        is: joi.exist(),
        then: joi.allow(null),
        otherwise: joi.allow(null),
      }),
    distance: joi.number().allow(null),
    currentLat: joi.number().when("distance", {
      is: joi.number(),
      then: joi.required(),
      otherwise: joi.allow(null),
    }),
    currentLng: joi.number().when("distance", {
      is: joi.number(),
      then: joi.required(),
      otherwise: joi.allow(null),
    }),
    rating:joi.number().allow(null),
    categories:joi.array().items(joi.number().optional()),
    subCategories:joi.array().items(joi.number().optional()),
    brands:joi.array().items(joi.number().optional()),
    models:joi.array().items(joi.number().optional()),
  }),
  productId: joi.string(),
  vendor: joi.boolean().when("productId", {
    is: joi.exist(),
    then: joi.optional(),
    otherwise: joi.forbidden(),
  }),
  search: joi.string().when("productId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
  vendorId: joi.string().when("productId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
  grid: joi.boolean().when("productId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
  categoryId: joi.string().when("productId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
});
export const getVendorSchema = joi.object({
  search: joi.string().when("vendorId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
  rating: joi
    .string()
    .regex(/^\d$/)
    .pattern(/^[1-5]$/)
    .messages({
      "string.pattern.base": "Rating must be a number between 1 to 5",
    }),
  positiveReviews: joi.boolean(),
  currentLat: joi.string(),
  currentLng: joi.string(),
  vendorId: joi.string().optional(),
  sort: joi.string().when("productId", {
    is: joi.exist(),
    then: joi.forbidden(),
    otherwise: joi.optional(),
  }),
});
export const getReviewSchema = joi.object({
  vendorId: joi.string().required(),
  sort: joi.string().optional(),
});
export const checkProductAvailability = joi.object({
  startDate: joi.date().format("YYYY-MM-DD").required(),
  endDate: joi.date().format("YYYY-MM-DD").required(),
  products: joi
    .array()
    .items(
      joi.object({
        id: joi.number().required(),
        quantity: joi.number().required(),
      })
    )
    .required(),
});
export const addCart = joi.object({
  startDate: joi.date().format("YYYY-MM-DD").required(),
  endDate: joi.date().format("YYYY-MM-DD").required(),
  productId: joi.number().required(),
  quantity: joi.number().required(),
  price: joi.number().required(),
  paidDays: joi.number().required(),
});
export const privacySchema = joi.object({
  title: joi.string(),
  name: joi.string().required(),
  description: joi.string().required(),
  type: joi.string().valid("PRIVACY", "COMMUNITY", "TERMS").required(),
});
export const submitId = joi.object({
  fileData: joi.array().items(joi.binary().required()).required(),
});
export const constactus = joi.object({
  firstName: joi.string().required(),
  lastName: joi.string().required(),
  email: joi.string().email().required(),
  subjectId: joi.number().strict(true).required(),
  message: joi.string().required(),
});
