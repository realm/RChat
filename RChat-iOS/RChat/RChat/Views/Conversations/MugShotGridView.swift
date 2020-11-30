//
//  MugShotGridView.swift
//  RChat
//
//  Created by Andrew Morgan on 26/11/2020.
//

import SwiftUI

struct MugShotGridView: View {
    let photos: [Photo]
    
    let height: CGFloat = 50.0
    
    let rows = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHGrid(rows: rows, alignment: .center, spacing: 0) {
                ForEach(photos) { photo in
                    // TODO: use real online state
                    UserAvatarView(photo: photo, online: true)
                }
            }
            .frame(height: height)
        }
    }
}

// swiftlint:disable line_length
struct MugShotGridView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            MugShotGridView(photos: [.sample, .sample2, .sample3, .sample, .sample2, .sample3, .sample, .sample2, .sample3, .sample, .sample2, .sample3])
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
