//
//  User.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: String
    let fullName: String
    var age: Int
    var profileImageURLs: [String]
    
}
