//
//  datingAppApp.swift
//  datingApp
//
//  Created by Balogun Kayode on 18/07/2024.
//

import SwiftUI

@main
struct datingAppApp: App {
    @StateObject var matchManager = MatchManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(matchManager)
        }
    }
}
