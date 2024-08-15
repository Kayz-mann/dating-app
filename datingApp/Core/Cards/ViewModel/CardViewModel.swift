//
//  CardViewModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//


import Foundation
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore




@MainActor
class CardViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction?
    
    private let auth: Auth
    private let db = Firestore.firestore()
    
    private let service: CardService

    init(service: CardService, auth: Auth) {
        self.service = service
        self.auth = auth
        Task { await fetchCardModels() }
    }
    


    func fetchCardModels() async {
        do {
            // Fetch the current user ID from Firebase Authentication
            guard let currentUserId = auth.currentUser?.email else {
                print("DEBUG: Current user ID is not available")
                return
            }
            
            // Fetch the current user data
                       let currentUser = try await fetchCurrentUser(email: currentUserId)
                       
           // Get the user's interest
           guard let interestedIn = currentUser.interestedIn else {
               print("DEBUG: Current user interest is not available")
               return
           }
          
            // Get the matched users
            let matchedUsers = currentUser.matchedUsers ?? []
            
            
            // Fetch card models excluding the current user
            self.cardModels = try await service.fetchCardModels(
//                interestedIn: interestedIn,
//                excluding: currentUserId,
                currentUser: currentUser,
                matchedUsers: matchedUsers
            )
            
        } catch {
            print("DEBUG: Failed to fetch cards with error \(error)")
        }
    }

    func removeCard(_ card: CardModel) {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000) // Simulate delay
            guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
            cardModels.remove(at: index)
        }
    }
    
    //Fetch current user from Fiurestore
    private func fetchCurrentUser(email: String) async throws -> User {
            let snapshot = try await db.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
            
            guard let document = snapshot.documents.first else {
                throw NSError(domain: "CardViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
            
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
                likedUsers: data["likedUsers"] as? [String]
            )
        }}


//import Foundation
//
////@MainActor
//class CardViewModel: ObservableObject {
//    @Published var cardModels = [CardModel]()
//    @Published var buttonSwipeAction: SwipeAction?
//    
//    private let service: CardService
//    
//    init(service: CardService) {
//        self.service = service
//        Task { await fetchCardModels()}
//    }
//    
//    func fetchCardModels()  async{
//        do {
//            self.cardModels = try await service.fetchCardModels()
//        }catch {
//            print("DEBUG: Failed to fetch cards with error \(error)")
//        }
//    }
//    
//    func removeCard(_ card: CardModel) {
//        Task {
//            try await Task.sleep(nanoseconds: 500_000_000)
//            guard let index = cardModels.firstIndex(where: {$0.id == card.id}) else {return}
//            cardModels.remove(at: index)
//        }
//        
//        //remove card as a collection by index from an array.
//    }
//}
