//
//  AttachButton.swift
//  RChat
//
//  Created by Andrew Morgan on 03/12/2020.
//

import SwiftUI

struct AttachButton: View {
    let action: () -> Void
    var active = true
    
    var body: some View {
        ButtonTemplate(action: action, active: active, activeImage: "paperclip", inactiveImage: "paperclip")
    }
}

struct AttachButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                AttachButton(action: {}, active: false)
                AttachButton(action: {})
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
