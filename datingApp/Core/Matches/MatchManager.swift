//
//  MatchManager.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import Foundation
import Combine

@MainActor
class MatchManager: ObservableObject {
    @Published var matchedUser: User?

    var matchedUserPublisher: AnyPublisher<User?, Never> {
        $matchedUser.eraseToAnyPublisher()
    }

    func checkForMatch(withUser user: User) {
        let didMatch = Bool.random()
        
        if didMatch {
            matchedUser = user
        }
    }
}

