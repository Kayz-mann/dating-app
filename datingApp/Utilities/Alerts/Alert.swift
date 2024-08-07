////
////  Alert.swift
////  datingApp
////
////  Created by Balogun Kayode on 02/08/2024.
////
//



import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    // Custom Alert Item for dynamic error messages
    static func customErrorAlert(message: String) -> AlertItem {
        AlertItem(
            title: Text("Sign Up Error"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
    
    // Default Alerts
    static let invalidLogin = AlertItem(
        title: Text("Server Error"),
        message: Text("Invalid email or password"),
        dismissButton: .default(Text("OK"))
    )
    
    static let emptyLoginField = AlertItem(
        title: Text("Error"),
        message: Text("Email and password cannot be empty."),
        dismissButton: .default(Text("OK"))
    )
    
    // Specific Firebase Error Alerts
    static func firebaseErrorAlert(for error: String) -> AlertItem {
        switch error {
        case "The email address is already in use by another account.":
            return AlertItem(
                title: Text("Sign-Up Failed"),
                message: Text("The email address is already in use. Please use a different email address."),
                dismissButton: .default(Text("OK"))
            )
        case "The password is invalid or the user does not have a password.":
            return AlertItem(
                title: Text("Sign-Up Failed"),
                message: Text("The password is invalid. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        case "The email address is badly formatted.":
            return AlertItem(
                title: Text("Sign-Up Failed"),
                message: Text("The email address is badly formatted. Please enter a valid email address."),
                dismissButton: .default(Text("OK"))
            )
        default:
            return customErrorAlert(message: error)
        }
    }

    // Function to create a custom alert item based on error message
    static func alert(forMessage errorMessage: String) -> AlertItem {
        return customErrorAlert(message: errorMessage)
    }
}


//import SwiftUI
//
//struct AlertItem: Identifiable {
//    let id = UUID()
//    let title: Text
//    let message: Text
//    let dismissButton: Alert.Button
//    
//}
//
//struct AlertContext {
//    let errorMessage: String?
//    //Login Network Alert
//    static let invalidLogin = AlertItem(title: Text("Server Error"), message: Text("Invalid email or password"), dismissButton: .default(Text("OK")))
//    
//    static let emptyLoginField = AlertItem(title: Text("Error"), message: Text("Email and password cannot be empty."), dismissButton: .default(Text("OK")))
//
//    
//    // Function to create a custom alert item based on ErrorModel
//    static func alert(for error: ErrorModel) -> AlertItem {
//        switch error {
//        case .invalidEmailOrPassword:
//            return AlertContext.invalidLogin
//        case .invalidLogin:
//            return AlertContext.invalidLogin
//        
//        case  .emptyLoginField:
//        return AlertContext.emptyLoginField
//
//        }
//    }
//}
