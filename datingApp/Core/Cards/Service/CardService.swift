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
    
//    func populateFirestoreWithMockData() {
//        let users = MockData.users
//        for user in users {
//            let userDocument = db.collection("users").document(user.id ?? "")
//            userDocument.setData([
//                "id": user.id!,
//                "fullName": user.fullName,
//                "age": user.age,
//                "email": user.email,
//                "profileImageURLs": user.profileImageURLs,
//                "occupation": user.occupation as Any,
//                "zodiacSign": user.zodiacSign as Any,
//                "sexualOrientation": user.sexualOrientation as Any,
//                "userBio": user.userBio as Any,
//                "likedUsers": user.likedUsers as Any,
//                "matchedUsers": user.matchedUsers ?? []// store user IDs
//            ]) { error in
//                if let error = error {
//                    print("Error writing user to Firestore: \(error)")
//                }
//            }
//        }
//    }
    
    func fetchCardModels() async throws -> [CardModel] {
        let snapshot = try await db.collection("users").getDocuments()
        let users = try snapshot.documents.compactMap { document -> User? in
            try? document.data(as: User.self)
        }
        return users.map { CardModel(user: $0) }
    }
}
