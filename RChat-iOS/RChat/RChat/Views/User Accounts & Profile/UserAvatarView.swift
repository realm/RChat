//
//  UserAvatarView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct UserAvatarView: View {
    let photo: Photo?
    let online: Bool
    var size: Size = .small
    var action: () -> Void = {}
    
    private var imageSize: CGFloat { size == .small ? 30.0 : 52.0 }
    private var buttonSize: CGFloat { size == .small ? 36.0 : 62.0 }
    
    let cornerRadius: CGFloat = 50.0
    
    var body: some View {
        Button(action: action) {
            ZStack {
                image
                    .cornerRadius(cornerRadius)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        OnOffCircleView(online: online, size: size)
                    }
                }
            }
        }
        .frame(width: buttonSize, height: buttonSize)
    }
    
    var image: some View {
        Group<AnyView> {
            if let image = photo {
                return AnyView(ThumbnailPhotoView(photo: image, imageSize: imageSize))
            } else {
                return AnyView(BlankPersonIconView().frame(width: imageSize, height: imageSize))
            }
        }
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                UserAvatarView(photo: .sample, online: true, size: .large, action: {})
                UserAvatarView(photo: .sample, online: false, size: .small, action: {})
            }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
