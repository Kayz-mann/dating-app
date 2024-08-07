//
//  CardStackView.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import SwiftUI


struct CardStackView: View {
    @State private var showMatchView = false
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var authService: AuthService

    @StateObject var viewModel = CardViewModel(service: CardService())
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    ZStack {
                        ForEach(viewModel.cardModels) { card in
                            CardView(model: card, viewModel: viewModel)
                        }
                    }
                    if !viewModel.cardModels.isEmpty {
                        // If the cards have all been swiped, remove the swipe action button
                        SwipeActionButtonView(viewModel: viewModel)
                    }
                }
                .blur(radius: showMatchView ? 20 : 0)

                if showMatchView {
                    UserMatchView(show: $showMatchView)
                }
            }
            .animation(.easeInOut, value: showMatchView)
            .onReceive(matchManager.$matchedUser, perform: { user in
                showMatchView = user != nil
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: signOut) {
                        Image(.tinderLogo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88)
                    }
                }
            }
        }
    }
    
    private func signOut() {
        authService.logOut { result in
            switch result {
            case .success:
                print("Successfully signed out")
        
            case .failure(let error):
                print("Sign-out failed: \(error.localizedDescription)")
                // Handle sign-out failure, e.g., display an alert
            }
        }
    }
}

#Preview {
    CardStackView()
}
