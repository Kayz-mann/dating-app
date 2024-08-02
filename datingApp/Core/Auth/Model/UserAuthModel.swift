//
//  UserAuthModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 31/07/2024.
//

import Foundation



enum FormTextField {
    case email, password
}


struct UserAuthModel: Codable {
    var email = ""
    var password = ""
}
