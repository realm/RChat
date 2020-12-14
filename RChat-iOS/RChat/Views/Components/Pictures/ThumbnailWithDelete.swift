//
//  ThumbnailWithDelete.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import SwiftUI

struct ThumbnailWithDelete: View {
    let photo: Photo?
    var action: (() -> Void)?
    
    private enum Dimensions {
        static let frameSize: CGFloat = 100
        static let imageSize: CGFloat = 70
        static let buttonSize: CGFloat = 30
        static let radius: CGFloat = 8
        static let buttonPadding: CGFloat = 4
    }
    
    var body: some View {
        ZStack {
            ThumbNailView(photo: photo)
            .frame(width: Dimensions.imageSize, height: Dimensions.imageSize, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            if let action = action {
                VStack {
                    HStack {
                        Spacer()
                        DeleteButton(action: action, padding: Dimensions.buttonPadding)
                            .frame(width: Dimensions.buttonSize, height: Dimensions.buttonSize, alignment: .center)
                    }
                    Spacer()
                }
                .frame(width: Dimensions.frameSize, height: Dimensions.frameSize)
            }
        }
    }
}

struct ThumbnailWithDelete_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ThumbnailWithDelete(photo: .sample, action: {})
                ThumbnailWithDelete(photo: .sample)
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
