exports = function() {
  const dbName = context.values.get("dbName");
  const db = context.services.get("mongodb-atlas").db(dbName);
  const chatCollection = db.collection("ChatMessage");
  
  return chatCollection.count()
  .then(result => {
    return result
  }, error => {
    console.log(`Failed to count ChatMessage documents: ${error}`);
  });
};