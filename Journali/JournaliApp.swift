//
//  JournaliApp.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

@main
struct JournaliApp: App {
    @State private var showSplash = true

    // How long the splash screen stays before the main screen appears
    private let splashDuration: Duration = .seconds(2)

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(.dark)
            .task {
                try? await Task.sleep(for: splashDuration)
                withAnimation { showSplash = false }
            }
        }
    }
}
