//
//  PreviewHelpers.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct AppearancePreviews<Value: View>: View {
    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    var body: some View {
        Group {
            viewToPreview
            viewToPreview.preferredColorScheme(.dark)
        }
    }
}

struct Landscape<Value: View>: View {
    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }
    let height = UIScreen.main.bounds.width
    let width = UIScreen.main.bounds.height
    var body: some View {
        viewToPreview
            .previewLayout(.fixed(width: width, height: height))
    }
}
