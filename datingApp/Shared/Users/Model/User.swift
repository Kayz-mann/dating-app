//
//  User.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var fullName: String
    var age: Int
    var email: String
    var profileImageURLs: [String]
    var occupation: String?
    var zodiacSign: String?
    var sexualOrientation: String?
    var userBio: String?
    var matchedLikes: [User]?
    var interestedIn: String?
    var matchedUsers: [String]?
    var likedUsers: [String]?
    
}
