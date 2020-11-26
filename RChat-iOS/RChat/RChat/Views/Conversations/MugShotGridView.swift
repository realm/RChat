//
//  MugShotGridView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI

struct MugShotGridView: View {
    let photos: [Photo]
    
    let rows = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .center, spacing: 10) {
                ForEach(photos) { photo in
//                    UserAvatarView(photo: photo, online: <#T##Bool#>)
                }
            }
        }
    }
}

struct MugShotGridView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            MugShotGridView(photos: [.sample, .sample])
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
