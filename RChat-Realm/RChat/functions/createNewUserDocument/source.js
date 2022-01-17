exports = function({user}) {
  const db = context.services.get("mongodb-atlas").db("RChat");
  const userCollection = db.collection("User");
  
  const partition = `user=${user.id}`;
  const defaultLocation = context.values.get("defaultLocation");
  const userPreferences = {
    displayName: user.data.email
  };
  
  console.log(`user: ${JSON.stringify(user)}`);
  
  const userDoc = {
    _id: user.id,
    partition: partition,
    userName: user.data.email,
    userPreferences: userPreferences,
    location: context.values.get("defaultLocation"),
    lastSeenAt: null,
    presence:"Off-Line",
    conversations: []
  };
  
  return userCollection.insertOne(userDoc)
  .then(result => {
    console.log(`Added User document with _id: ${result.insertedId}`);
  }, error => {
    console.log(`Failed to insert User document: ${error}`);
  });
};