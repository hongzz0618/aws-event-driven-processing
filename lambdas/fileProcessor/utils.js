const AWS = require("aws-sdk");

const sns = new AWS.SNS();
const sqs = new AWS.SQS();

function parseS3Event(event) {
  // EventBridge -> detail.bucket.name / detail.object.key
  if (event?.detail?.bucket?.name && event?.detail?.object?.key) {
    return {
      bucket: event.detail.bucket.name,
      key: decodeURIComponent(event.detail.object.key),
    };
  }
  // fallback por si llega formato S3 raw (no debería en este patrón)
  if (event?.Records?.[0]?.s3?.bucket?.name) {
    return {
      bucket: event.Records[0].s3.bucket.name,
      key: decodeURIComponent(event.Records[0].s3.object.key),
    };
  }
  throw new Error("Unrecognized S3 event format");
}

async function publishNotification(topicArn, subject, payload) {
  await sns
    .publish({
      TopicArn: topicArn,
      Subject: subject.slice(0, 100),
      Message: JSON.stringify(payload),
    })
    .promise();
}

async function enqueueMessage(queueUrl, payload) {
  await sqs
    .sendMessage({
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(payload),
    })
    .promise();
}

module.exports = {
  parseS3Event,
  publishNotification,
  enqueueMessage,
};
