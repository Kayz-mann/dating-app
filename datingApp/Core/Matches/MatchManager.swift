//
//  MatchManager.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

@MainActor
class MatchManager: ObservableObject {
    @Published var matchedUser: User?
    @Published var userList: [User] = [] // To store the list of users for matching
    @Published var matchedUsers: [User] = [] // To store the matched users
    @Published var searchText: String = ""
    private var db = Firestore.firestore() // Reference to Firestore
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        fetchMatchedUsers()
    }
    
    var matchedUserPublisher: AnyPublisher<User?, Never> {
        $matchedUser.eraseToAnyPublisher()
    }
    
    func checkForMatch(withUser user: User) {
        // Retrieve the current user's email from Auth
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        // Fetch the current user from Firestore
        db.collection("users").whereField("email", isEqualTo: currentUserEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching current user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No document found for email: \(currentUserEmail)")
                return
            }
            
            let data = document.data()
            
            // Unwrap the data and create the currentUser object
            guard let currentUserId = document.documentID as String?,
                  let fullName = data["fullName"] as? String,
                  let age = data["age"] as? Int,
                  let email = data["email"] as? String,
                  let profileImageURLs = data["profileImageURLs"] as? [String] else {
                print("Error parsing current user data.")
                return
            }
            
            var currentUser = User(
                id: currentUserId,
                fullName: fullName,
                age: age,
                email: email,
                profileImageURLs: profileImageURLs,
                occupation: data["occupation"] as? String,
                zodiacSign: data["zodiacSign"] as? String,
                sexualOrientation: data["sexualOrientation"] as? String,
                userBio: data["userBio"] as? String,
                matchedLikes: data["matchedLikes"] as? [User],
                interestedIn: data["interestedIn"] as? String,
                matchedUsers: data["matchedUsers"] as? [String],
                likedUsers: data["likedUsers"] as? [String] ?? [] // Handle missing field
            )
            
            // Proceed with matching logic
            self.checkForMatch(withUser: user, currentUser: currentUser)
        }
    }
    
    private func checkForMatch(withUser user: User, currentUser: User) {
        guard let currentUserId = currentUser.id, let likedUsers = user.likedUsers else { return }
        
        // Check if the current user is in the likedUsers of the other user
        if likedUsers.contains(currentUserId) {
            // Add both users to the matchedUsers array
            addMatchToUsers(currentUser: currentUser, matchedUser: user)
        } else {
            // Add the current user ID to the likedUsers array of the other user
            addUserToLikedUsers(user: user, currentUserId: currentUserId)
        }
    }
    
    private func addUserToLikedUsers(user: User, currentUserId: String) {
        var updatedUser = user
        var likedUsers = updatedUser.likedUsers ?? []
        
        if !likedUsers.contains(currentUserId) {
            likedUsers.append(currentUserId)
            updatedUser.likedUsers = likedUsers
            updateUserInFirestore(user: updatedUser)
        }
    }
    
    private func addMatchToUsers(currentUser: User, matchedUser: User) {
        // Update current user's matchedUsers array
        var updatedCurrentUser = currentUser
        var matchedUsers = updatedCurrentUser.matchedUsers ?? []
        
        if let matchedUserId = matchedUser.id, !matchedUsers.contains(matchedUserId) {
            matchedUsers.append(matchedUserId)
            updatedCurrentUser.matchedUsers = matchedUsers
            updateUserInFirestore(user: updatedCurrentUser)
        }
        
        // Update matched user's matchedUsers array
        var updatedMatchedUser = matchedUser
        var matchedUserMatches = updatedMatchedUser.matchedUsers ?? []
        
        if let currentUserId = currentUser.id, !matchedUserMatches.contains(currentUserId) {
            matchedUserMatches.append(currentUserId)
            updatedMatchedUser.matchedUsers = matchedUserMatches
            updateUserInFirestore(user: updatedMatchedUser)
        }
        
        // Notify about the match
        DispatchQueue.main.async {
            self.matchedUser = matchedUser
        }
    }
    
    private func updateUserInFirestore(user: User) {
        guard let userId = user.id else { return }
        
        db.collection("users").document(userId).updateData([
            "likedUsers": user.likedUsers ?? [],
            "matchedUsers": user.matchedUsers ?? []
        ]) { error in
            if let error = error {
                print("Error updating user in Firestore: \(error.localizedDescription)")
            } else {
                print("User successfully updated in Firestore.")
            }
        }
    }
    
    func filterUsersForCurrentUser(currentUserId: String) -> [User] {
        return userList.filter { $0.id != currentUserId }
    }
    
    func fetchMatchedUsers() {
            guard let currentUserEmail = Auth.auth().currentUser?.email else {
                print("No current user email found.")
                return
            }
            
            // Fetch the current user's document
            db.collection("users").whereField("email", isEqualTo: currentUserEmail).getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching current user: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No current user document found.")
                    return
                }
                
                let data = document.data()
                guard let matchedUserEmails = data["matchedUsers"] as? [String] else {
                    print("No matched users found for current user.")
                    return
                }
                
                // Query users based on matched user emails
                self?.queryMatchedUsers(emails: matchedUserEmails)
            }
        }
        
        private func queryMatchedUsers(emails: [String]) {
            db.collection("users").whereField("email", in: emails).getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching matched users: \(error.localizedDescription)")
                    return
                }
                
                self?.matchedUsers = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return User(
                        id: document.documentID,
                        fullName: data["fullName"] as? String ?? "",
                        age: data["age"] as? Int ?? 0,
                        email: data["email"] as? String ?? "",
                        profileImageURLs: data["profileImageURLs"] as? [String] ?? [],
                        occupation: data["occupation"] as? String,
                        zodiacSign: data["zodiacSign"] as? String,
                        sexualOrientation: data["sexualOrientation"] as? String,
                        userBio: data["userBio"] as? String,
                        matchedLikes: data["matchedLikes"] as? [User],
                        interestedIn: data["interestedIn"] as? String,
                        matchedUsers: data["matchedUsers"] as? [String],
                        likedUsers: data["likedUsers"] as? [String] ?? []
                    )
                } ?? []
            }
        }
    
    @Published var users: [User] = []
    
//    var filteredUsers: [User] {
//        if searchText.isEmpty {
//            print("All match====", users)
//            return users
//        } else {
//            return users.filter { $0.fullName.contains(searchText) }
//        }
//    }
    
}
 
