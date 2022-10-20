//
//  MarkDown.swift
//  MarkDown
//
//  Created by Andrew Morgan on 13/09/2021.
//

import SwiftUI

struct MarkDown: View {
    let text: String

    var body: some View {
        Text(safeAttributedString(text))
    }
}

private func safeAttributedString(_ sourceString: String) -> AttributedString {
    do {
        return try AttributedString(markdown: sourceString)
    } catch {
        print("Failed to convert Markdown to AttributedString: \(error.localizedDescription)")
        return try! AttributedString(markdown: "Text could not be rendered")
    }
}

struct MarkDown_Previews: PreviewProvider {
    static var previews: some View {
        MarkDown(text: "Sample of *italics*, **bold**, ~~strikethrough~~, [link](https://realm.io)")
    }
}
