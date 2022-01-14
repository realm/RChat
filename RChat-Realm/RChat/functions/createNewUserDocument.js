exports = async function({user}) {
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
    userName: user.data.email,
    userPreferences: userPreferences,
    location: context.values.get("defaultLocation"),
    lastSeenAt: null,
    presence:"Off-Line",
    conversations: []
  };
  
  await userCollection.insertOne(userDoc);
};