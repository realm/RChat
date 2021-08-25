exports = function (changeEvent) {
  console.log("In copyToChatMessageV2");
  const db = context.services.get("mongodb-atlas").db("RChat");
  
  if (changeEvent.operationType === "delete") {
    console.log("It's a delete");
    return db.collection("ChatMessageV2").deleteOne({ _id: changeEvent.documentKey._id });
  }
  
  const author = changeEvent.fullDocument.author ? changeEvent.fullDocument.author : "Unknown";

  console.log(`author = ${author}`);

  const pipeline = [
    { $match: { _id: changeEvent.documentKey._id } },
    {
      $addFields: {
        author: author,
      }
    },
    { $merge: "ChatMessageV2" }];
    
  console.log("About to run pipeline");
  return db.collection("ChatMessage").aggregate(pipeline);
};