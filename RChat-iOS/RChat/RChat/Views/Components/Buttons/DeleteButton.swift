//
//  DeleteButton.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import SwiftUI

struct DeleteButton: View {
    let action: () -> Void
    var active = true
    var padding: CGFloat = 8
    
    var body: some View {
        ButtonTemplate(action: action, active: active, activeImage: "minus.square.fill", inactiveImage: "minus.square", padding: padding)
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                DeleteButton(action: {}, active: false)
                DeleteButton(action: {})
                DeleteButton(action: {}, padding: 4)
            }
        )
        .previewLayout(.sizeThatFits)
    }
}
