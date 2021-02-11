//
//  ThumbnailWithExpand.swift
//  RChat
//
//  Created by Andrew Morgan on 07/12/2020.
//

import SwiftUI

struct ThumbnailWithExpand: View {
    let photo: Photo
    
    @State private var showingFullImage = false
    
    private enum Dimensions {
        static let frameSize: CGFloat = 100
        static let imageSize: CGFloat = 70
        static let buttonSize: CGFloat = 30
        static let radius: CGFloat = 8
        static let buttonPadding: CGFloat = 4
    }
    
    var body: some View {
        VStack {
            Button(action: { showingFullImage = true }) {
                ThumbNailView(photo: photo)
                    .frame(width: Dimensions.imageSize, height: Dimensions.imageSize, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: Dimensions.radius))
            }
            NavigationLink(destination: PhotoFullSizeView(photo: photo), isActive: $showingFullImage) {
                EmptyView()
            }
        }
    }
}

struct ThumbnailWithExpand_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            NavigationView {
                ThumbnailWithExpand(photo: .sample)
            }
        )
    }
}
