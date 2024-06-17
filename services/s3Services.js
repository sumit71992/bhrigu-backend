import AWS from "aws-sdk";

const uploadToS3 = async (data, filename, mimetype) => {
  try {
    let s3bucket = new AWS.S3({
      accessKeyId: process.env.AWS_USER_KEY,
      secretAccessKey: process.env.AWS_SECRET_KEY,
    });
    let fileDetails = {
      Bucket: process.env.AWS_USER_BUCKET,
      Key: filename,
      Body: data,
      ACL: "public-read",
      ContentType: mimetype,
    };
    return new Promise((resolve, reject) => {
      s3bucket.upload(fileDetails, (err, response) => {
        if (err) {
          reject(err);
        } else {
          resolve(response.Location);
        }
      });
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({ err, message: "Something went wrong" });
  }
};
export const deleteFromS3 = async (filename) => {
  try {
    const s3bucket = new AWS.S3({
      accessKeyId: process.env.AWS_USER_KEY,
      secretAccessKey: process.env.AWS_SECRET_KEY,
    });

    const deleteParams = {
      Bucket: process.env.AWS_USER_BUCKET,
      Key: filename,
    };

    return new Promise((resolve, reject) => {
      s3bucket.deleteObject(deleteParams, (err, data) => {
        if (err) {
          reject(err);
        } else {
          resolve(data);
        }
      });
    });
  } catch (err) {
    console.error(err);
    throw new Error('Something went wrong while deleting from S3');
  }
};
export default uploadToS3;

