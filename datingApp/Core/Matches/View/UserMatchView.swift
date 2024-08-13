//
//  UserMatchView.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserMatchView: View {
    @Binding var show: Bool
    @EnvironmentObject var matchedManager: MatchManager
    
    @State private var currentUser: User? // State to hold the current user
    @State private var currentUserImage: String? // State to hold the current user's profile image URL

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.7))
                .ignoresSafeArea()
            
            VStack(spacing: 120) {
                VStack {
                    Text("It's A Match")
                        .foregroundStyle(.white)
                    
                    if let matchedUser = matchedManager.matchedUser {
                        Text("You and \(matchedUser.fullName) have liked each other.")
                            .foregroundStyle(.white)
                    }
                }
                
                HStack(spacing: 16) {
                    if let imageURL = currentUserImage {
                        Image(uiImage: loadImage(from: imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 4)
                            }
                    }
                    
                    if let matchedUser = matchedManager.matchedUser {
                        Image(uiImage: loadImage(from: matchedUser.profileImageURLs.first ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 4)
                            }
                    }
                }
                
                VStack(spacing: 16) {
                    Button("Send Message") {
                        show.toggle()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: 44)
                    .background(.primaryPink)
                    .clipShape(Capsule())
                    
                    Button("Keep Swiping") {
                        show.toggle()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: 44)
                    .background(.clear)
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .stroke(.white, lineWidth: 1)
                            .shadow(radius: 4)
                    }
                }
            }
            .onAppear {
                fetchCurrentUser()
            }
        }
    }
    
    // Function to fetch current user from Firestore
    private func fetchCurrentUser() {
        guard let email = Auth.auth().currentUser?.email else {
            print("No current user email found.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching current user: \(error.localizedDescription)")
                return
            }
            
            if let document = snapshot?.documents.first {
                let data = document.data()
                
                // Extract profile image URL from the first item in the array
                if let profileImageURLs = data["profileImageURLs"] as? [String], !profileImageURLs.isEmpty {
                    self.currentUserImage = profileImageURLs.first
                }
            } else {
                print("No document found for email: \(email)")
            }
        }
    }
    
    // Function to load image from URL
    private func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else { return UIImage() }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            print("Error loading image: \(error)")
            return UIImage()
        }
    }
}

#Preview {
    UserMatchView(show: .constant(true))
        .environmentObject(MatchManager(appState: AppState()))
}
