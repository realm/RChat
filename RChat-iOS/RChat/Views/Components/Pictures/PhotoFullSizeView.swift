//
//  PhotoFullSizeView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import UIKit
import SwiftUI

struct PhotoFullSizeView: View {
    let photo: Photo

    var body: some View {
        VStack {
            if let picture = photo.picture {
                if let image = UIImage(data: picture) {
                    Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}

struct PhotoFullSizeView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            NavigationView {
                PhotoFullSizeView(photo: .sample)
            }
        )
    }
}
