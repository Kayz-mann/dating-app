//
//  ContentView.swift
//  datingApp
//
//  Created by Balogun Kayode on 18/07/2024.
//

import SwiftUI
import KeychainSwift

struct ContentView: View {
    @EnvironmentObject var authService: AuthService


    var body: some View {
        NavigationStack {
            if authService.user == nil {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            } else if authService.isProfileComplete {
                MainTabView()
                    .navigationBarBackButtonHidden(true)
            } else {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            }
        }
        .onChange(of: authService.isProfileComplete) { newValue in
            print("isProfileComplete changed to: \(newValue)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
        .environmentObject(AppState())
        .environmentObject(MatchManager(appState: AppState()))}


//// Add this to your AppDelegate or a place where it will be called once at app launch
//func initializeCloudinaryConfigFromEnv() {
//    let url = "https://api.cloudinary.com/v1_1/afrotronika/image/upload"
//    let uploadPreset = "ml_default"
//    
//    let keychain = KeychainSwift()
//    keychain.set(url, forKey: "cloudinaryURL")
//    keychain.set(uploadPreset, forKey: "uploadPreset")
//}
