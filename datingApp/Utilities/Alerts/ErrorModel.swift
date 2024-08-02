//
//  ErrorModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 02/08/2024.
//

import Foundation

enum ErrorModel: Error, LocalizedError {
    case invalidEmailOrPassword
    case invalidLogin
    case emptyLoginField
}
