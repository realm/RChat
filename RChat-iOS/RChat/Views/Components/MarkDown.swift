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
        Text(try! AttributedString(markdown: text))
    }
}

struct MarkDown_Previews: PreviewProvider {
    static var previews: some View {
        MarkDown(text: "Sample of *italics*, **bold**, ~~strikethrough~~, [link](https://realm.io) 😀 😃 😄 😁 😆")
    }
}
