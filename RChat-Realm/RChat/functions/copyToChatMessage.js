exports = function (changeEvent) {
  const db = context.services.get("mongodb-atlas").db("RChat");
  
  if (changeEvent.operationType === "delete") {
    return db.collection("ChatMessage").deleteOne({ _id: changeEvent.documentKey._id })
  }

  const pipeline = [
    { $match: { _id: changeEvent.documentKey._id } },
    { $merge: "ChatMessage" }]
  return db.collection("ChatMessageV2").aggregate(pipeline);
};