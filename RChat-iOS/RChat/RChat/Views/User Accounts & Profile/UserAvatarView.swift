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
    var action: () -> Void = {}
    
    // TODO: Tidy these up
    private let imageSize: CGFloat = 30
    private let buttonSize: CGFloat = 36
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
                        OnOffCircleView(online: online)
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
            UserAvatarView(photo: .sample, online: true, action: {})
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
