//
//  PreviewNoDevice.swift
//  Black Jack Trainer
//
//  Created by Andrew Morgan on 15/10/2021.
//

import SwiftUI

struct PreviewNoDevice<Value: View>: View {
    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    var body: some View {
        Group {
            viewToPreview
                .previewLayout(.sizeThatFits)
//                .padding()
        }
    }
}
