exports = function(changeEvent) {
  if (changeEvent.operationType != "insert") {
    console.log(`ChatMessage ${changeEvent.operationType} event – currently ignored.`);
    return;
  }
  
  console.log(`ChatMessage Insert event being processed`);
  let userCollection = context.services.get("mongodb-atlas").db("RChat").collection("User");
  let chatMessage = changeEvent.fullDocument;
  let conversation = "";
  
  if (chatMessage.partition) {
    const splitPartition = chatMessage.partition.split("=");
    if (splitPartition.length == 2) {
      conversation = splitPartition[1];
      console.log(`Partition/converstion = ${conversation}`);
    } else {
      console.log("Couldn't extract the conversation from partition ${chatMessage.partition}");
      return;
    }
  } else {
    console.log("partition not set");
    return;
  }
  
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
  
  userCollection.updateMany(matchingUserQuery, updateOperator, arrayFilter)
  .then ( result => {
    console.log(`Matched ${result.matchedCount} User docs; updated ${result.modifiedCount}`);
  }, error => {
    console.log(`Failed to match and update User docs: ${error}`);
  });

  /*
    A Database Trigger will always call a function with a changeEvent.
    Documentation on ChangeEvents: https://docs.mongodb.com/manual/reference/change-events/

    Access the _id of the changed document:
    const docId = changeEvent.documentKey._id;

    Access the latest version of the changed document
    (with Full Document enabled for Insert, Update, and Replace operations):
    const fullDocument = changeEvent.fullDocument;

    const updateDescription = changeEvent.updateDescription;

    See which fields were changed (if any):
    if (updateDescription) {
      const updatedFields = updateDescription.updatedFields; // A document containing updated fields
    }

    See which fields were removed (if any):
    if (updateDescription) {
      const removedFields = updateDescription.removedFields; // An array of removed fields
    }

    Functions run by Triggers are run as System users and have full access to Services, Functions, and MongoDB Data.

    Access a mongodb service:
    const collection = context.services.get("mongodb-atlas").db("RChat").collection("ChatMessage");
    const doc = collection.findOne({ name: "mongodb" });

    Note: In Atlas Triggers, the service name is defaulted to the cluster name.

    Call other named functions if they are defined in your application:
    const result = context.functions.execute("function_name", arg1, arg2);

    Access the default http client and execute a GET request:
    const response = context.http.get({ url: <URL> })

    Learn more about http client here: https://docs.mongodb.com/realm/functions/context/#context-http
  */
};
