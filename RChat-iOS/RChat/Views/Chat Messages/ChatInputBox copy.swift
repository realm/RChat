//
//  ChatInputBox.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

import SwiftUI
import UIKit

struct ChatInputBox: View {
    var clicked: (String, Photo) -> Void
    
    private enum Dimensions {
        static let maxHeight: CGFloat = 100
        static let minHeight: CGFloat = 100
        static let radius: CGFloat = 20
        static let imageSize: CGFloat = 100
    }
    
    @State var photo: Photo?
    @State var chatText = "Type your message"
    
    var body: some View {
        HStack {
            AddPhotoButton(action: takePhoto, photo: photo)
                .frame(
                    width: photo != nil ? Dimensions.imageSize : Dimensions.imageSize / 2,
                    height: Dimensions.imageSize,
                    alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            TextEditor(text: $chatText)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: Dimensions.minHeight, maxHeight: Dimensions.maxHeight)
                .background(Color("GreenBackground"))
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
        }
        .onAppear(perform: { clearBackground() })
    }
    
    func takePhoto() {
        // TODO: Implement
    }
    
    func clearBackground() {
        UITextView.appearance().backgroundColor = .clear
    }
}

struct ChatInputBox_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                NavigationView {
                    ChatInputBox { (_, _) in }
                }
                NavigationView {
                    ChatInputBox(clicked: { (_, _) in }, photo: .sample)
                }
            }
        )
    }
}
