//
//  JournalCard.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

// One card in the journal list
struct JournalCard: View {
    let journal: Journal
    let onBookmark: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(journal.title)
                    .font(Theme.titleCard)
                    .foregroundStyle(Theme.accentText)

                Spacer()

                Button(action: onBookmark) {
                    Image(systemName: journal.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(journal.isBookmarked ? Theme.primary : Theme.textPrimary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(journal.isBookmarked ? "Remove Bookmark" : "Bookmark")
            }

            Text(journal.date.shortText)
                .font(Theme.captionS)
                .foregroundStyle(Theme.textSecondary)

            Text(journal.text)
                .font(Theme.bodyM)
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}