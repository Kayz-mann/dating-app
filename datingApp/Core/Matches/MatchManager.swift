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
    private var db = Firestore.firestore() // Reference to Firestore
    private var appState: AppState

    init(appState: AppState) {
        self.appState = appState
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
            
            print("Number of documents found: \(snapshot?.count ?? 0)")
            print("current email:", currentUserEmail)
            
            guard let document = snapshot?.documents.first else {
                print("No document found for email here: \(currentUserEmail)")
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
}


//import Foundation
//import Combine
//
//@MainActor
//class MatchManager: ObservableObject {
//    @Published var matchedUser: User?
//
//    var matchedUserPublisher: AnyPublisher<User?, Never> {
//        $matchedUser.eraseToAnyPublisher()
//    }
//
//    func checkForMatch(withUser user: User) {
//        let didMatch = Bool.random()
//        
//        if didMatch {
//            matchedUser = user
//        }
//    }
//}

