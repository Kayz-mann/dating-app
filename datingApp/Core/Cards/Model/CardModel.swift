//
//  CardModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation

struct CardModel {
    let user: User
}

extension CardModel: Identifiable, Hashable {
    var id: String { return user.id! }
}
