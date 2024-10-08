//
//  MainTabView.swift
//  datingApp
//
//  Created by Balogun Kayode on 18/07/2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CardStackView()
                .tabItem { Image(systemName: "flame") }
                .tag(0)
                
            SearchView()
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(1)
            
            Text("Chat View")
//            ChatView()
                .tabItem { Image(systemName: "bubble") }
                .tag(2)
            
            
            
            CurrentUserProfileView()
//                CurrentUserProfileView(user: MockData.users[1])
                .tabItem { Image(systemName: "person") }
                .tag(3)

        }
        .tint(.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MatchManager(appState: AppState()))       
        .environmentObject(AppState())
}
