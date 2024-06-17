export const rawBodyMiddleware = (req, res, next) => {
  req.rawBody = Buffer.alloc(0);
  req.on("data", (chunk) => {
    req.rawBody = Buffer.concat([req.rawBody, chunk]);
  });
  req.on("end", () => {
    // req.body = JSON.parse(req.rawBody.toString());
    req.body = req.rawBody
    next();
  });
};
