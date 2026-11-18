//
//  EmptyStateView.swift
//  Journali
//
//  Created by Nada on 08/06/1448 AH.
//


//
//  EmptyStateView.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

// Shown when there are no journals yet
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("openBook")
                .resizable()
                .scaledToFit()
                .frame(width: 140)

            Text("Begin Your Journal")
                .font(Theme.headingM)
                .foregroundStyle(Theme.accentText)

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(Theme.captionM)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}