//
//  cred_vueApp.swift
//  cred-vue
//
//  Created by Aman Kumar Singh on 28/09/25.
//

import SwiftUI
internal import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn = false
}

@main
struct MyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                ContentView().environmentObject(appState)
                    .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                OnboardingView(show: .constant(true)).environmentObject(appState)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}
