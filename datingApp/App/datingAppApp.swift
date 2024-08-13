//
//  datingAppApp.swift
//  datingApp
//
//  Created by Balogun Kayode on 18/07/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
// ...



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
      


@main
struct datingAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var matchManager = MatchManager()
    @StateObject var authService = AuthService()
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(matchManager)
                .environmentObject(appState)
        }
    }
}
