exports = async function(changeEvent) {
  const dbName = context.values.get("dbName");
  const db = context.services.get("mongodb-atlas").db(dbName);
  const chatster = db.collection("Chatster");
  const userCollection = db.collection("User");
  let eventCollection = context.services.get("mongodb-atlas").db("RChat").collection("Event");
  const docId = changeEvent.documentKey._id;
  const user = changeEvent.fullDocument;
  let conversationsChanged = false;
  
  console.log(`Mirroring user for docId=${docId}. operationType = ${changeEvent.operationType}`);
  switch (changeEvent.operationType) {
    case "insert":
    case "replace":
    case "update":
      console.log(`Writing data for ${user.userName}`);
      let chatsterDoc = {
        _id: user._id,
        userName: user.userName,
        lastSeenAt: user.lastSeenAt,
        presence: user.presence
      };
      if (user.userPreferences) {
        const prefs = user.userPreferences;
        chatsterDoc.displayName = prefs.displayName;
        if (prefs.avatarImage && prefs.avatarImage._id) {
          console.log(`Copying avatarImage`);
          chatsterDoc.avatarImage = prefs.avatarImage;
          console.log(`id of avatarImage = ${prefs.avatarImage._id}`);
        }
      }
      console.log('About to replaceOne Chatster doc');
      await chatster.replaceOne({ _id: user._id }, chatsterDoc, { upsert: true });
      if (user.conversations && user.conversations.length > 0) {
        for (i = 0; i < user.conversations.length; i++) {
          let membersToAdd = [];
          if (user.conversations[i].members.length > 0) {
            for (j = 0; j < user.conversations[i].members.length; j++) {
              if (user.conversations[i].members[j].membershipStatus == "User added, but invite pending") {
                membersToAdd.push(user.conversations[i].members[j].userName);
                user.conversations[i].members[j].membershipStatus = "Membership active";
                conversationsChanged = true;
              }
            }
          } 
          if (membersToAdd.length > 0) {
            await userCollection.updateMany({userName: {$in: membersToAdd}}, {$push: {conversations: user.conversations[i]}});
          }
        }
      }
      if (conversationsChanged) {
        userCollection.updateOne({_id: user._id}, {$set: {conversations: user.conversations}});
      }
      break;
    case "delete":
      await chatster.deleteOne({_id: docId});
      break;
  }
};