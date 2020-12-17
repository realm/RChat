# RChat – A Chat app built with SwiftUI and Realm

RChat is a chat application. Members of a chat room share messages, photos, location, and presence information with each other. The initial version is an iOS (Swift & SwiftUI) app, but we will use the same data model and backend Realm application to build an Android version in the future.

![Screenshot of a chatroom with messages](assets/ChatRoom.png)

## Building and running the app

1. If you don't already have one, [create a MongoDB Atlas Cluster](https://cloud.mongodb.com/), keeping the default name of `Cluster0`.
1. Install the [Realm CLI](https://docs.mongodb.com/realm/deploy/realm-cli-reference) and [create an API key pair](https://docs.atlas.mongodb.com/configure-api-access#programmatic-api-keys).
1. Download the repo and install the Realm app:
```
git clone https://github.com/ClusterDB/RChat.git
cd RChat/RChat-Realm/RChat
realm-cli login --api-key <your new public key> --private-api-key <your new private key>
realm-cli import # Then answer prompts, naming the app RChat
```
4. From the Atlas UI, click on the Realm logo and you will see the RChat app. Open it and copy the App Id

![Realm application Id](assets/realm-app-id.png)

5. (Optional) Use `mongoimport` to import the empty database from the `dump` folder to create database indexes
1. Open the iOS project
```
cd ../../RChat-iOS
open RChat.xcodeproj
```
7. Update `RChatApp.swift` with your Realm App Id and then build