//
//  CurrentUserViewModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 04/09/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class CurrentUserViewModel: ObservableObject {
    @Published var user: User?
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth() // Assuming you use FirebaseAuth
    
    func fetchCurrentUser() {
        guard let userId = auth.currentUser?.email else {
            return
        }
        
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self)
                } catch {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("User does not exist")
            }
        }
    }
}

