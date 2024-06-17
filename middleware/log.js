import UAParser from "ua-parser-js";
import { prisma } from "../app.js";

export const Logs = async (req, message) => {
  try {
    const { method, url } = req;
    const ip = req.headers["x-forwarded-for"] || req.connection.remoteAddress;
    const userAgent = req.headers["user-agent"];
    const parser = new UAParser();
    const uaResult = parser.setUA(userAgent).getResult();
    const browser = `${uaResult.browser.name} ${uaResult.browser.version}`;
    const os = `${uaResult.os.name} ${uaResult.os.version}`;
    const device = uaResult.device.type || "Desktop";
    return await prisma.log.create({
      data: {
        userId: req.user.id,
        route: url,
        method,
        ipAddress: ip,
        browser,
        device,
        os,
        message,
      },
    });
  } catch (err) {
    console.log("LogsError",err);
    return null;
  }
};
