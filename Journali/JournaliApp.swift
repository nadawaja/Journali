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
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                withAnimation { showSplash = false }
            }
        }
    }
}
