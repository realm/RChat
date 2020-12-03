//
//  ThumbNailView.swift
//  RChat
//
//  Created by Andrew Morgan on 02/12/2020.
//

import SwiftUI

struct ThumbNailView: View {
    let photo: Photo?
    
    var body: some View {
        VStack {
            if let photo = photo {
                if photo.thumbNail != nil || photo.picture != nil {
                    if let photo = photo.thumbNail {
                        Thumbnail(imageData: photo)
                    } else {
                        if let photo = photo.picture {
                            Thumbnail(imageData: photo)
                        } else {
                            Thumbnail(imageData: UIImage().jpegData(compressionQuality: 0.8)!)
                        }
                    }
                }
            }
//            else {
//                Thumbnail(imageData: UIImage().jpegData(compressionQuality: 0.8)!)
//            }
        }
    }
}

struct ThumbNailView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ThumbNailView(photo: .sample)
                ThumbNailView(photo: nil)
            }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
