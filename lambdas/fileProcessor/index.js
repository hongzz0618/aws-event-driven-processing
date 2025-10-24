const {
  publishNotification,
  enqueueMessage,
  parseS3Event,
} = require("./utils");

exports.handler = async (event) => {
  const log = (...args) => console.log("[fileProcessor]", ...args);
  log("Event received:", JSON.stringify(event, null, 2));

  // EventBridge formatea S3 -> detail
  const { bucket, key } = parseS3Event(event);

  // Mensaje base
  const message = {
    bucket,
    key,
    receivedAt: new Date().toISOString(),
  };

  // Publicar en SNS
  await publishNotification(
    process.env.SNS_TOPIC_ARN,
    `New file uploaded: s3://${bucket}/${key}`,
    message
  );

  // Enviar a SQS
  await enqueueMessage(process.env.SQS_QUEUE_URL, message);

  return { status: "ok", file: `s3://${bucket}/${key}` };
};
