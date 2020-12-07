//
//  OnOffCircleView.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import SwiftUI

struct OnOffCircleView: View {
    let online: Bool
    
    // TODO: Tidy these uo
    private let frameSize: CGFloat = 14.0
    private let innerCircleSize: CGFloat = 10
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: frameSize, height: frameSize)
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
                OnOffCircleView(online: true)
            }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
