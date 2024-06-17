import fs from "fs";
import path from "path";
import cron from "node-cron";
import moment from "moment";
import { exec } from "child_process";
import { URL } from "url";
import { Constants } from "./services/Constants.js";
import { prisma } from "./app.js";

// Schedule tasks
const futureTime = moment().add(1, "minutes").format("mm HH DD MM *");
const midnight = "1 0 * * *";
cron.schedule(midnight, async () => {
  try {
    const thirtyDaysAgo = moment().subtract(30, "days").toDate();
    await Promise.allSettled([
      prisma.log.deleteMany({ where: { createdAt: { lt: thirtyDaysAgo } } }),
      performDatabaseBackup(),
    ]);
    console.log("Logs older than 30 days have been deleted successfully.");
  } catch (err) {
    console.error(err);
  }
});
export const performDatabaseBackup = () => {
  const date = new Date().toISOString().slice(0, 10);
  const backupFileName = `gearghost_${date}.sql`;
  const backupDirectory = "databaseBackup";
  if (!fs.existsSync(backupDirectory)) {
    fs.mkdirSync(backupDirectory);
  }
  const command = `mysqldump --user=${process.env.MYSQL_USER} --password=${
    process.env.MYSQL_PASSWORD
  } --host=${process.env.MYSQL_HOST} --port=${process.env.MYSQL_PORT}  ${
    process.env.MYSQL_DATABASE
  } > ${path.join(backupDirectory, backupFileName)}`;
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error("Backup failed:", err);
    } else {
      console.log("Backup successful!");
      fs.readdir(backupDirectory, (err, files) => {
        if (err) {
          console.error("Error reading backup directory:", err);
        } else {
          const threeDaysAgo = new Date();
          threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
          files.forEach((file) => {
            const filePath = path.join(backupDirectory, file);
            console.log("filepath", filePath);
            fs.stat(filePath, (err, stats) => {
              if (err) {
                console.error(`Error getting file stats: ${filePath}`, err);
              } else {
                if (stats.isFile() && stats.mtime < threeDaysAgo) {
                  deleteFile(filePath);
                }
              }
            });
          });
        }
      });
    }
  });
};
function deleteFile(filePath) {
  fs.unlink(filePath, (err) => {
    if (err) {
      console.error(`Error deleting file: ${filePath}`, err);
    } else {
      console.log(`Deleted file: ${filePath}`);
    }
  });
}
export default cron;
