//
//  Alert.swift
//  datingApp
//
//  Created by Balogun Kayode on 02/08/2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    
}

struct AlertContext {
    let errorMessage: String?
    //Login Network Alert
    static let invalidLogin = AlertItem(title: Text("Server Error"), message: Text("Invalid email or password"), dismissButton: .default(Text("OK")))
    
    static let emptyLoginField = AlertItem(title: Text("Error"), message: Text("Email and password cannot be empty."), dismissButton: .default(Text("OK")))

    
    // Function to create a custom alert item based on ErrorModel
    static func alert(for error: ErrorModel) -> AlertItem {
        switch error {
        case .invalidEmailOrPassword:
            return AlertContext.invalidLogin
        case .invalidLogin:
            return AlertContext.invalidLogin
        
        case  .emptyLoginField:
        return AlertContext.emptyLoginField

        }
    }
}
