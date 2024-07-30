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
        if authService.user != nil {
            MainTabView()
        } else {
            LoginView()
        }
    }
    
}

#Preview {
    ContentView()
}
