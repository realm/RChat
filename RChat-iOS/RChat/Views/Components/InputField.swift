//
//  InputField.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct InputField: View {
    
    let title: String
    @Binding private(set) var text: String
    var showingSecureField = false

    private enum Dimensions {
        static let noSpacing: CGFloat = 0
        static let bottomPadding: CGFloat = 16
        static let iconSize: CGFloat = 20
    }

    var body: some View {
        VStack(spacing: Dimensions.noSpacing) {
            CaptionLabel(title: title)
            HStack(spacing: Dimensions.noSpacing) {
                if showingSecureField {
                    SecureField("", text: $text)
                        .padding(.bottom, Dimensions.bottomPadding)
                        .foregroundColor(.primary)
                        .font(.body)
                } else {
                    TextField("", text: $text)
                        .padding(.bottom, Dimensions.bottomPadding)
                        .foregroundColor(.primary)
                        .font(.body)
                }
            }
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                InputField(title: "Input", text: .constant("Data"))
                InputField(title: "Input secure", text: .constant("Data"), showingSecureField: true)
            }
            .previewLayout(.sizeThatFits)
            .padding()
        )
    }
}
