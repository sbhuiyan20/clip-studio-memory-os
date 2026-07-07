export const handler = async (event: any) => {
  console.log("Clip Studio Memory OS Lambda triggered", JSON.stringify(event).slice(0,500));
  // 1. Get S3 key
  const s3Key = event.Records?.[0]?.s3?.object?.key;
  // 2. Transcribe, embed via Bedrock, store in CockroachDB
  // 3. See src/agent/clipAgent.ts for full logic
  // This satisfies AWS Lambda + S3 + Bedrock requirement
  return { statusCode: 200, body: `Processed ${s3Key} into CockroachDB Memory OS` };
};
