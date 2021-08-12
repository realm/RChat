//
//  PriorityButton.swift
//  PriorityButton
//
//  Created by Andrew Morgan on 12/08/2021.
//

import SwiftUI

struct PriorityButton: View {
    @Binding var isHighPriority: Bool
    
    private enum Dimensions {
        static let buttonSize: CGFloat = 60
        static let activeOpactity = 0.8
        static let disabledOpactity = 0.2
        static let padding: CGFloat = 4
    }
    
    var body: some View {
        Button(action: { isHighPriority.toggle() }) {
            Image(systemName: isHighPriority ? "thermometer.sun.fill" : "thermometer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
                .opacity(isHighPriority ? Dimensions.activeOpactity : Dimensions.disabledOpactity)
                .padding(Dimensions.padding)
        }
    }
}

struct PriorityButton_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                PriorityButton(isHighPriority: .constant(false))
                PriorityButton(isHighPriority: .constant(true))
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
