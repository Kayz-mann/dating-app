//
//  CardService.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//


import Foundation
import FirebaseFirestore

struct CardService {
    private let db = Firestore.firestore()
    
    func fetchCardModels(currentUser: User, matchedUsers: [String]) async throws -> [CardModel] {
        let snapshot = try await db.collection("users")
//            .whereField("interestedIn", isEqualTo: currentUser.gender)
            .whereField("email", isNotEqualTo: currentUser.email)
            .getDocuments()
        
        print("DEBUG: Number of documents fetched: \(snapshot.documents.count)")
        
        return snapshot.documents
            .filter { !matchedUsers.contains($0.documentID) }
            .compactMap { document in
                do {
                    let user = try document.data(as: User.self)
                    return CardModel(user: user)
                } catch {
                    print("Error decoding user for document ID: \(document.documentID), Error: \(error)")
                    return nil
                }
            }
    }
}

//import Foundation
//import FirebaseFirestore
//
//struct CardService {
//    private let db = Firestore.firestore()
//        
//    func fetchCardModels() async throws -> [CardModel] {
//        let snapshot = try await db.collection("users").getDocuments()
//        let users = try snapshot.documents.compactMap { document -> User? in
//            try? document.data(as: User.self)
//        }
//        return users.map { CardModel(user: $0) }
//    }
//}
