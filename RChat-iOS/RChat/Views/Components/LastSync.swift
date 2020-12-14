//
//  LastSync.swift
//  RChat
//
//  Created by Andrew Morgan on 27/11/2020.
//

import SwiftUI

struct LastSync: View {
    let date: Date
    
    var body: some View {
            HStack {
                Text("Last synced")
                Text(date, style: .relative)
                Text("ago")
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct LastSync_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            LastSync(date: Date())
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
