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
                if authService.isProfileComplete == true {
                    MainTabView()
                }
                else if  authService.isProfileComplete == false {
                    LoginView()
                }
                
            } else {
                LoginView()
            }
        }.navigationBarBackButtonHidden(true)
        .onChange(of: authService.isProfileComplete) { newValue in
            print("isProfileComplete changed to: \(authService.isProfileComplete)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
        .environmentObject(AppState())
}
