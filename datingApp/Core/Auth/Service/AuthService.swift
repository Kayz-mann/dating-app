//
//  AuthService.swift
//  datingApp
//
//  Created by Balogun Kayode on 27/07/2024.
//

import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var user: User? = nil
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, firebaseUser in
            self.user = self.convertToAppUser(firebaseUser: firebaseUser)
        }
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let appUser = self.convertToAppUser(firebaseUser: firebaseUser)
                completion(.success(appUser!))
            }
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                let appUser = self.convertToAppUser(firebaseUser: firebaseUser)
                completion(.success(appUser!))
            }
        }
    }
    
    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func convertToAppUser(firebaseUser: FirebaseAuth.User?) -> User? {
        guard let firebaseUser = firebaseUser else { return nil }
        return User(
            id: firebaseUser.uid,
            fullName: firebaseUser.displayName ?? "",
            age: 0,  // Placeholder, you'll need to get the actual age from your user profile data
            email: firebaseUser.email ?? "",
            profileImageURLs: [],  // Placeholder, you'll need to get the actual URLs from your user profile data
            occupation: nil,  // Placeholder, get actual data from your user profile
            zodiacSign: nil,  // Placeholder, get actual data from your user profile
            sexualOrientation: nil,  // Placeholder, get actual data from your user profile
            userBio: nil,  // Placeholder, get actual data from your user profile
            matchedLikes: nil  // Placeholder, get actual data from your user profile
        )
    }
}
