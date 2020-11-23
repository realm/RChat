//
//  SwiftUIView.swift
//  RChat
//
//  Created by Andrew Morgan on 23/11/2020.
//

import SwiftUI

struct LastUpdate: View {
    let date: Date

    var body: some View {
        HStack {
            Text("Last updated ")
            Text(date, style: .relative)
            Text("ago")
            Spacer()
        }
        .font(.caption)
        .lineLimit(5)
        .multilineTextAlignment(.leading)
        .foregroundColor(.secondary)
    }
}

struct LastUpdate_Previews: PreviewProvider {
    static var previews: some View {
        LastUpdate(date: Date())
    }
}
