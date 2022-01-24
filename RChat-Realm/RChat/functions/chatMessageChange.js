exports = async function(changeEvent) {
  if (changeEvent.operationType != "insert") {
    console.log(`ChatMessage ${changeEvent.operationType} event – currently ignored.`);
    return;
  }
  
  console.log(`ChatMessage Insert event being processed`);
  console.log(`context.user: ${JSON.stringify(context.user)}`);
  console.log(`context.user.id: ${context.user.id}`);
  const dbName = context.values.get("dbName");
  const db = context.services.get("mongodb-atlas").db(dbName);
  let userCollection = db.collection("User");
  let eventCollection = db.collection("Event");
  let chatMessage = changeEvent.fullDocument;
  let conversation = chatMessage.conversationID;
  console.log(`Message: ${JSON.stringify(chatMessage)}`);
  
  const matchingUserQuery = {
    conversations: {
      $elemMatch: {
        id: conversation
      }
    }
  };
  
  const updateOperator = {
      $inc: {
        "conversations.$[element].unreadCount": 1
      }
  };
  
  const arrayFilter = {
    arrayFilters:[
        {
          "element.id": conversation
        }
      ]
  };
  
  await eventCollection.insertOne(changeEvent);
  await userCollection.updateMany(matchingUserQuery, updateOperator, arrayFilter);
};
