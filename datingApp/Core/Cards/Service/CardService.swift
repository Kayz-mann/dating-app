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
    
    //        let users = MockData.users


    func fetchCardModels() async throws -> [CardModel] {
        let snapshot = try await db.collection("users").getDocuments()
        let users = try snapshot.documents.compactMap { document -> User? in
            try? document.data(as: User.self)
        }
        return users.map { CardModel(user: $0) }
    }
}
