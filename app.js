import express from "express";
import { fileURLToPath } from "url";
import path from "path";
import { createServer } from "http";
import { Server } from "socket.io";
import compression from "compression";
import cors from "cors";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import swaggerUi from "swagger-ui-express";
import { PrismaClient } from "@prisma/client";
import swaggerSpec from "./swagger.js";
import fileUpload from "express-fileupload";
import { initializeSocketIO } from "./socket.js";
import auth from "./routes/authRoute.js";
import cron from "./cronJob.js";
// import webhook from "./routes/webhookRoute.js";

export const prisma = new PrismaClient();

dotenv.config();
const port = process.env.PORT || 8000;

const app = express();
const httpServer = createServer(app);
app.get("/health", (req, res) => {
  const port = req.connection.remotePort;
  const url = req.protocol + "://" + req.get("host") + req.originalUrl;
  console.log("Request received on port:", port);
  console.log("Request URL:", url);
  res.send("Sever Working Fine");
});
app.use(cors());
app.use(cookieParser());

// app.use("/", webhook);

app.use(express.json({ limit: "500mb" }));
app.use(express.urlencoded({ extended: true, limit: "500mb" }));
app.use(compression());
// app.use(helmet());
app.use(fileUpload());

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use("/auth", auth);

app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.set("port", port);
const io = new Server(httpServer, {
  cors: {
    origin: process.env.CORS_ORIGIN,
    credentials: true,
  },
});
app.set("io", io);
initializeSocketIO(io);
app.listen(port, () => {
  console.log(`App is running on port ${port}`);
});
