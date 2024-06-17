import express from "express";
import * as Controller from "../controllers/index.js";
import {authenticate} from "../middleware/auth.js";
import { rawBodyMiddleware } from "../middleware/raw.js";
const webhook = express.Router();



webhook.post("/webhook",rawBodyMiddleware,Controller.Merchant.handleWebhook);

export default webhook;