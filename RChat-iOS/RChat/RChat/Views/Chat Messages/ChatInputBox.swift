//
//  ChatInputBox.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

import SwiftUI
import UIKit

struct ChatInputBox: View {
    var send: (String, Photo?) -> Void
    var focusAction: () -> Void = {}
    
    private enum Dimensions {
        static let maxHeight: CGFloat = 100
        static let minHeight: CGFloat = 100
        static let radius: CGFloat = 10
        static let imageSize: CGFloat = 70
        static let padding: CGFloat = 15
        static let toolStripHeight: CGFloat = 35
    }
    
    @State var photo: Photo?
    @State var chatText = ""
    
    var isEmpty: Bool { photo == nil && chatText == "" }
    
    var body: some View {
        VStack {
            HStack {
                if let photo = photo {
                    ThumbnailWithDelete(photo: photo, action: deletePhoto)
                }
                TextEditor(text: $chatText)
                    .onTapGesture(perform: focusAction)
                    .padding(Dimensions.padding)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: Dimensions.minHeight, maxHeight: Dimensions.maxHeight)
                    .background(Color("GreenBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            }
            HStack {
                Spacer()
                AttachButton(action: addAttachment, active: photo == nil)
                CameraButton(action: takePhoto, active: photo == nil)
                SendButton(action: sendChat, active: !isEmpty)
            }
            .frame(height: Dimensions.toolStripHeight)
        }
        .padding(Dimensions.padding)
        .onAppear(perform: { clearBackground() })
    }
    
    func takePhoto() {
        PhotoCaptureController.show(source: .camera) { controller, photo in
            self.photo = photo
            controller.hide()
        }
    }
    
    func addAttachment() {
        PhotoCaptureController.show(source: .photoLibrary) { controller, photo in
            self.photo = photo
            controller.hide()
        }
    }
    
    func deletePhoto() {
        photo = nil
    }
    
    func sendChat() {
        send(chatText, photo)
        photo = nil
        chatText = ""
    }
    
    func clearBackground() {
        UITextView.appearance().backgroundColor = .clear
    }
}

struct ChatInputBox_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ChatInputBox { (_, _) in }
                ChatInputBox(send: { (_, _) in }, photo: .sample)
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
