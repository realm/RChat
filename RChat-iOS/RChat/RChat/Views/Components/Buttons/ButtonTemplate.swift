//
//  ButtonTemplate.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import SwiftUI

struct ButtonTemplate: View {
    let action: () -> Void
    var active = true
    var activeImage = "paperplane.fill"
    var inactiveImage = "paperplane"
    var padding: CGFloat = 4
    
    private enum Dimensions {
        static let buttonSize: CGFloat = 60
    }
    
    var body: some View {
        Button(action: { if active { action() } }) {
            Image(systemName: active ? activeImage : inactiveImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
                .opacity(active ? 0.8 : 0.2)
                .padding(padding)
        }
//        .frame(maxWidth: Dimensions.buttonSize, maxHeight: Dimensions.buttonSize, alignment: .center)
    }
}

struct ButtonTemplate_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ButtonTemplate(action: {})
                ButtonTemplate(action: {}, active: false)
                ButtonTemplate(action: {}, active: false, activeImage: "camera.fill", inactiveImage: "camera")
                ButtonTemplate(action: {}, active: true, activeImage: "camera.fill", inactiveImage: "camera")
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
