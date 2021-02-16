//
//  SearchBox.swift
//  RChat
//
//  Created by Andrew Morgan on 08/12/2020.
//

import SwiftUI

struct SearchBox: View {
    var placeholder: String = "Search"
    @Binding var searchText: String

    private enum Dimensions {
        static let inset: CGFloat = 7.0
        static let bottomInset: CGFloat = 4.0
        static let heightTextField: CGFloat = 36.0
        static let cornerRadius: CGFloat = 10.0
        static let padding: CGFloat = 16.0
        static let topPadding: CGFloat = 15.0
        static let glassSize: CGFloat = 24.0
        static let dividerHeight: CGFloat = 1.0
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: Dimensions.glassSize, height: Dimensions.glassSize)
                TextField(placeholder,
                          text: $searchText
                )
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .font(.body)
            }
            .padding(EdgeInsets(top: Dimensions.inset, leading: Dimensions.bottomInset, bottom: Dimensions.inset, trailing: Dimensions.inset))
            .frame(height: Dimensions.heightTextField)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Dimensions.cornerRadius)
            .padding([.horizontal, .top], Dimensions.padding)
            Divider()
                .padding(.top, Dimensions.topPadding)
                .frame(height: Dimensions.dividerHeight)
        }
    }
}

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            SearchBox(
                searchText: .constant("")
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
