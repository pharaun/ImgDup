//
//  SearchView.swift
//  ImgDup
//
//  Created by Anja Berens on 1/19/26.
//

import SwiftUI

struct SearchView: View {
    @FocusState private var isSearchFocused: Bool
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    Color(.secondaryLabelColor)
                )
            
            TextField(
                "Search",
                text: $searchText,
            )
            .textFieldStyle(.plain)
            .padding(.vertical, 8)
            .focused($isSearchFocused)
            
            if searchText != "" {
                Button(action: {
                    searchText = ""
                }) {
                    Image(
                        systemName: "xmark.circle.fill"
                    )
                    .foregroundStyle(
                        Color(.secondaryLabelColor)
                    )
                }
                .padding(.horizontal, -8)
                .buttonStyle(.borderless)
            }
        }
        .padding(.horizontal)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(
                cornerRadius: 20
            ).stroke(
                isSearchFocused ? Color(.blue) :
                    Color(.systemGray).opacity(0.3),
                lineWidth: isSearchFocused ? 2 : 1
            )
        )
    }
}


// Demo Data
struct Demo: Identifiable {
    let id = UUID()
    let text: String
}

#Preview {
    @Previewable @State var search = ""
    SearchView(searchText: $search)
    
    // For searchable
    List([Demo(text: "asdf"), Demo(text: "asdf")]) {
        Text($0.text)
    }.searchable(text: $search)
}
