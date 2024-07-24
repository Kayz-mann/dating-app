//
//  MockData.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation

struct MockData {
    static let users: [User] = [
        .init(id: NSUUID().uuidString, fullName: "Brad Fox", age: 32, profileImageURLs: ["pic1", "pic2"]),
        
        .init(id: NSUUID().uuidString, fullName: "Meghan Fox", age: 22, profileImageURLs: ["pic2", "pic3"]),
        
        .init(id: NSUUID().uuidString, fullName: "Allen Smith", age: 25, profileImageURLs: ["pic3", "pic4"])

    ]
}
