//
//  CardService.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation

struct CardService {
    func fetchCardModels() async throws -> [CardModel] {
        let users = MockData.users
        
        return users.map({CardModel(user: $0)})
    }
}
