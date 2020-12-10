exports = function(changeEvent) {
  const db = context.services.get("mongodb-atlas").db("RChat");
  const chatster = db.collection("Chatster");
  const userCollection = db.collection("User");
  const docId = changeEvent.documentKey._id;
  const user = changeEvent.fullDocument;
  let conversationsChanged = false;
  
  // TODO: If it's an update, then check what's changed and only take the actions needed
  
  console.log(`Mirroring user for docId=${docId}. operationType = ${changeEvent.operationType}`);
  switch (changeEvent.operationType) {
    case "insert":
    case "replace":
    case "update":
      console.log(`Writing data for ${user.userName}`);
      let chatsterDoc = {
        _id: user._id,
        partition: "all-users=all-the-users",
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
      chatster.replaceOne({ _id: user._id }, chatsterDoc, { upsert: true })
      .then (() => {
        console.log(`Wrote Chatster document for _id: ${docId}`);
      }, error => {
        console.log(`Failed to write Chatster document for _id=${docId}: ${error}`);
      });
      
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
            userCollection.updateMany({userName: {$in: membersToAdd}}, {$push: {conversations: user.conversations[i]}})
            .then (result => {
              console.log(`Updated ${result.modifiedCount} other User documents`);
            }, error => {
              console.log(`Failed to copy new conversation to other users: ${error}`);
            });
          }
        }
      }
      if (conversationsChanged) {
        userCollection.updateOne({_id: user._id}, {$set: {conversations: user.conversations}});
      }
      break;
    case "delete":
      chatster.deleteOne({_id: docId})
      .then (() => {
        console.log(`Deleted Chatster document for _id: ${docId}`);
      }, error => {
        console.log(`Failed to delete Chatster document for _id=${docId}: ${error}`);
      });
      break;
  }
};