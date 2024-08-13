//
//  CardStackView.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import SwiftUI
import FirebaseAuth

struct CardStackView: View {
    @State private var showMatchView = false
    @EnvironmentObject var matchManager: MatchManager
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var appState: AppState

    @StateObject private var viewModel: CardViewModel

    init() {
        // Initialize with a placeholder currentUserId
        _viewModel = StateObject(wrappedValue: CardViewModel(service: CardService(), auth: Auth.auth()))
    }

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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: signOut) {
                        Image("tinderLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 88)
                    }
                }
            }
        }
        .task {
            // Fetch card models with the correct currentUserId
            await viewModel.fetchCardModels()
        }
    }

    private func signOut() {
        authService.logOut { result in
            switch result {
            case .success:
                authService.isProfileComplete = false
                print("Successfully signed out")
            case .failure(let error):
                print("Sign-out failed: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    CardStackView()
        .environmentObject(MatchManager())
        .environmentObject(AuthService())
        .environmentObject(AppState())
}
