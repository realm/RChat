//
//  PreviewOrientation.swift
//  Black Jack Trainer
//
//  Created by Andrew Morgan on 14/10/2021.
//

import SwiftUI

struct PreviewOrientation<Value: View>: View {
    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    var body: some View {
        Group {
            viewToPreview
            viewToPreview.previewInterfaceOrientation(.landscapeRight)
        }
    }
}
