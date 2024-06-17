import express from "express";
import * as Controller from "../controllers/index.js";
import { authenticate } from "../middleware/auth.js";
const auth = express.Router();

auth.post("/signup", Controller.Auth.signup);
auth.put("/otp",Controller.Auth.verifyOTP);
auth.patch("/otp", Controller.Auth.resendOtp);
auth.post("/signin", Controller.Auth.signin);
auth.put("/forgot-password", Controller.Auth.forgotPassword);
auth.put("/reset-password", Controller.Auth.resetPassword);
auth.patch("/logout",authenticate, Controller.Auth.logout);
auth.get("/refreshtoken",authenticate, Controller.Auth.refreshToken);

export default auth;