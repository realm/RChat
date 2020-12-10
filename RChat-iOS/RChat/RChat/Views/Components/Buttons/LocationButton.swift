//
//  LocationButton.swift
//  RChat
//
//  Created by Andrew Morgan on 09/12/2020.
//

import SwiftUI

struct LocationButton: View {
    let action: () -> Void
    var active = true
    
    var body: some View {
        ButtonTemplate(action: action, active: active, activeImage: "location.fill", inactiveImage: "location")
    }
}

struct LocationButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                LocationButton(action: {}, active: false)
                LocationButton(action: {})
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
