//
//  FilterMenu.swift
//  Journali
//
//  Created by Nada on 08/06/1448 AH.
//

import SwiftUI

// The filter button in the top bar
struct FilterMenu: View {
    @Binding var sortOption: SortOption

    var body: some View {
        Menu {
            Picker("Sort", selection: $sortOption) {
                Text("Sort by Bookmark").tag(SortOption.bookmark)
                Text("Sort by Entry Date").tag(SortOption.date)
            }
            .pickerStyle(.inline)
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
        }
        .accessibilityLabel("Filter")
    }
}
