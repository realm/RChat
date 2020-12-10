exports = function(partition) {
  console.log(`Checking if can sync a read for partition = ${partition}`);
  
  const db = context.services.get("mongodb-atlas").db("RChat");
  const chatsterCollection = db.collection("Chatster");
  const userCollection = db.collection("User");
  const chatCollection = db.collection("ChatMessage");
  const user = context.user;
  let partitionKey = "";
  let partitionVale = "";
  
  const splitPartition = partition.split("=");
  if (splitPartition.length == 2) {
    partitionKey = splitPartition[0];
    partitionValue = splitPartition[1];
    console.log(`Partition key = ${partitionKey}; partition value = ${partitionValue}`);
  } else {
    console.log(`Couldn't extract the partition key/value from ${partition}`);
    return;
  }
  
   switch (partitionKey) {
    case "user":
      console.log(`Checking if partitionValue(${partitionValue}) matches user.id(${user.id}) – ${partitionKey === user.id}`);
      return partitionValue === user.id;
    case "conversation":
      console.log(`Looking up User document for _id = ${user.id}`);
      return userCollection.findOne({ _id: user.id })
      .then (userDoc => {
        if (userDoc.conversations) {
          let foundMatch = false;
          userDoc.conversations.forEach( conversation => {
            console.log(`Checking if conversaion.id (${conversation.id}) === ${partitionValue}`)
            if (conversation.id === partitionValue) {
              console.log(`Found matching conversation element for id = ${partitionValue}`);
              foundMatch = true;
            }
          });
          if (foundMatch) {
            console.log(`Found Match`);
            return true;
          } else {
            console.log(`Checked all of the user's conversations but found none with id == ${partitionValue}`);
            return false;
          }
        } else {
          console.log(`No conversations attribute in User doc`);
          return false;
        }
      }, error => {
        console.log(`Unable to read User document: ${error}`);
        return false;
      });
    case "all-users":
      console.log(`Any user can read all-users partitions`);
      return true;
    default:
      console.log(`Unexpected partition key: ${partitionKey}`);
      return false;
   }
};
