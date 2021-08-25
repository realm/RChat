//
//  ChatBubbleView.swift
//  RChat
//
//  Created by Andrew Morgan on 04/12/2020.
//

import SwiftUI
import RealmSwift

struct ChatBubbleView: View {
    let chatMessage: ChatMessageV2
    let authorName: String?
    var isPreview = false
    
    private var isLessThanOneDay: Bool { chatMessage.timestamp.timeIntervalSinceNow > -60 * 60 * 24 }
    private var isMyMessage: Bool { authorName == nil }
    
    private enum Dimensions {
        static let padding: CGFloat = 4
        static let horizontalOffset: CGFloat = 100
        static let cornerRadius: CGFloat = 15
    }
    
    var body: some View {
        HStack {
            if isMyMessage { Spacer().frame(width: Dimensions.horizontalOffset) }
            VStack {
                HStack {
                    if chatMessage.isHighPriority {
                        Image(systemName: "thermometer.sun.fill")
                            .renderingMode(.original)
                    }
                    if let authorName = authorName {
                        if isPreview {
                            AuthorView(userName: authorName)
                        } else {
                            AuthorView(userName: authorName)
                                .environment(\.realmConfiguration, app.currentUser!.configuration(partitionValue: "all-users=all-the-users"))
                        }
                    }
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
                        .fontWeight(chatMessage.isHighPriority ? .bold : .regular)
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

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()
        
//        return AppearancePreviews(
            return Group {
                ChatBubbleView(chatMessage: .sample, authorName: "jane@contoso.com", isPreview: true)
                ChatBubbleView(chatMessage: .sample2, authorName: "freddy@contoso.com", isPreview: true)
                ChatBubbleView(chatMessage: .sample3, authorName: nil, isPreview: true)
                ChatBubbleView(chatMessage: .sample33, authorName: "jane@contoso.com", isPreview: true)
            }
//        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
