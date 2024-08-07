//
//  ContentView.swift
//  datingApp
//
//  Created by Balogun Kayode on 18/07/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        NavigationStack {
            if let user = authService.user {
                if authService.isProfileComplete {
                    MainTabView()
                } else {
                    TellUsMoreView()
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: authService.isProfileComplete) { newValue in
            print("isProfileComplete changed to: \(newValue)")
        }
    }
}

#Preview {
    ContentView()
}
