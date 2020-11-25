//
//  OnOffCircleView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct OnOffCircleView: View {
    let online: Bool
    let size: Size
    
    private var mapFrameSize: CGFloat { size == .small ? 14.0 : 25.0 }
    private var innerCircleSize: CGFloat { size == .small ? 10.0 : 18.0 }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: mapFrameSize, height: mapFrameSize)
            Circle()
                .fill(online ? Color.green : Color.red)
                .frame(width: innerCircleSize, height: innerCircleSize)
        }
    }
}

struct OnOffCircleView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                OnOffCircleView(online: true, size: .small)
                OnOffCircleView(online: false, size: .large)
            }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

enum Size {
    case small, large
}
