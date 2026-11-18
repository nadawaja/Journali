//
//  SplashView.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.background, Color(hex: 0x1A1A2E)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 8) {
                Image("notebook")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)

                Text("Journali")
                    .font(Theme.headingM)
                    .foregroundStyle(Theme.textPrimary)

                Text("Your thoughts, your story")
                    .font(Theme.captionS)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }
}
