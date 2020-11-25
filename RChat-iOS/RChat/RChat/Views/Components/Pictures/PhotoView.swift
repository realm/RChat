//
//  PhotoView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct PhotoView: View {
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

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .sample)
    }
}
