//
//  ChatBubbleView.swift
//  RChat
//
//  Created by Andrew Morgan on 04/12/2020.
//

import SwiftUI

struct ChatBubbleView: View {
    let chatMessage: ChatMessage
    let authorName: String?
//    var author: Chatster?
    
    private var isLessThanOneDay: Bool { chatMessage.timestamp.timeIntervalSinceNow > -60 * 60 * 24 }
    private var isMyMessage: Bool { authorName == nil }
    
    private enum Dimensions {
//        static let authorHeight: CGFloat = 25
        static let padding: CGFloat = 4
        static let horizontalOffset: CGFloat = 100
        static let cornerRadius: CGFloat = 15
    }
    
    var body: some View {
        HStack {
            if isMyMessage { Spacer().frame(width: Dimensions.horizontalOffset) }
            VStack {
                HStack {
                    if let authorName = authorName {
                        AuthorView(userName: authorName)
                            .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
                    }
//                    if let author = author {
//                        HStack {
//                            if let photo = author.avatarImage {
//                                AvatarThumbNailView(photo: photo, imageSize: Dimensions.authorHeight)
//                            }
//                            if let name = author.displayName {
//                                Text(name)
//                                .font(.caption)
//                            } else {
//                                Text(author.userName)
//                                    .font(.caption)
//                            }
//                            Spacer()
//                        }
//                        .frame(maxHeight: Dimensions.authorHeight)
//                        .padding(Dimensions.padding)
//                    }
                    Spacer()
                    Text(chatMessage.timestamp, style: isLessThanOneDay ?  .time : .date)
                        .font(.caption)
                }
                HStack {
                    if let photo = chatMessage.image {
                        ThumbnailWithExpand(photo: photo)
                        .padding(Dimensions.padding)
                    }
                    if let location = chatMessage.location {
                        if location.count == 2 {
                            MapThumbnailWithExpand(location: location.map { $0 })
                                .padding(Dimensions.padding)
                        }
                    }
                    if chatMessage.text != "" {
                        Text(chatMessage.text)
                        .padding(Dimensions.padding)
                    }
                    Spacer()
                }
            }
            .padding(Dimensions.padding)
            .background(Color(isMyMessage ? "MyBubble" : "OtherBubble"))
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.cornerRadius))
            if !isMyMessage { Spacer().frame(width: Dimensions.horizontalOffset) }
        }
    }
}

//struct ChatBubbleView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppearancePreviews(
//            Group {
//                ChatBubbleView(chatMessage: .sample, author: .sample)
//                ChatBubbleView(chatMessage: .sample3)
//                ChatBubbleView(chatMessage: .sample33)
//            }
//        )
//        .padding()
//        .previewLayout(.sizeThatFits)
//    }
//}
