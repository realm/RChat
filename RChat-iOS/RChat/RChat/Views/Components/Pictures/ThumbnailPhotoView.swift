//
//  ThumbnailPhotoView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct ThumbnailPhotoView: View {
    var photo: Photo
    
    var imageSize: CGFloat = 64
    var contentMode: ContentMode = .fill
    
    var body: some View {
        if photo.thumbNail != nil {
            let mugShot = UIImage(data: photo.thumbNail!)
            Image(uiImage: mugShot ?? UIImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: imageSize, height: imageSize)
        } else {
            Text("No thumbnail")
        }
        
    }
}

struct ThumbnailPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailPhotoView(photo: .sample)
    }
}
