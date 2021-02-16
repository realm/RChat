//
//  ChatInputBox.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

import SwiftUI
import RealmSwift

struct ChatInputBox: View {
    @EnvironmentObject var state: AppState
    @AppStorage("shouldShareLocation") var shouldShareLocation = false
    
    var send: (_: ChatMessage) -> Void = { _ in }
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
    @State var location =  [Double]()
    
    private var isEmpty: Bool { photo == nil && location == [] && chatText == "" }
    
    var body: some View {
        VStack {
            HStack {
                if let photo = photo {
                    ThumbnailWithDelete(photo: photo, action: deletePhoto)
                }
                if location.count == 2 {
                    MapThumbnailWithDelete(location: location, action: deleteMap)
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
                LocationButton(action: addLocation, active: shouldShareLocation && location.count == 0)
                AttachButton(action: addAttachment, active: photo == nil)
                CameraButton(action: takePhoto, active: photo == nil)
                SendButton(action: sendChat, active: !isEmpty)
            }
            .frame(height: Dimensions.toolStripHeight)
        }
        .padding(Dimensions.padding)
        .onAppear(perform: { clearBackground() })
    }
    
    private func addLocation() {
        let location = LocationHelper.currentLocation
        self.location = [location.longitude, location.latitude]
    }
    
    private func takePhoto() {
        PhotoCaptureController.show(source: .camera) { controller, photo in
            self.photo = photo
            controller.hide()
        }
    }
    
    private func addAttachment() {
        PhotoCaptureController.show(source: .photoLibrary) { controller, photo in
            self.photo = photo
            controller.hide()
        }
    }
    
    private func deletePhoto() {
        photo = nil
    }
    
    private func deleteMap() {
        location = []
    }
    
    private func sendChat() {
        sendMessage(text: chatText, photo: photo, location: location)
        photo = nil
        chatText = ""
        location = []
    }
    
    private func clearBackground() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    private func sendMessage(text: String, photo: Photo?, location: [Double]) {
            let chatMessage = ChatMessage(
                author: state.user?.userName ?? "Unknown",
                text: text,
                image: photo,
                location: location)
            send(chatMessage)
    }
}

struct ChatInputBox_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ChatInputBox()
                ChatInputBox(photo: .sample, location: [])
                ChatInputBox(photo: .sample, location: [-0.10689139236939127, 51.506520923981554])
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
