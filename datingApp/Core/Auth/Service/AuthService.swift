//
//  AuthService.swift
//  datingApp
//
//  Created by Balogun Kayode on 27/07/2024.
//

import FirebaseAuth
import Combine
import FirebaseFirestore


class AuthService: ObservableObject {
    @Published var user: User? = nil
    @Published var isProfileComplete: Bool = false // Ensure this is published
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, firebaseUser in
            self.user = self.convertToAppUser(firebaseUser: firebaseUser)
            if let email = self.user?.email {
                self.checkUserProfileCompletion(email: email) { isComplete in
                    DispatchQueue.main.async {
                        self.isProfileComplete = isComplete
                    }
                }
            } else {
                self.isProfileComplete = false
            }
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
                self.user = appUser
                self.checkUserProfileCompletion(email: email) { isComplete in
                    DispatchQueue.main.async {
                        self.isProfileComplete = isComplete
                    }
                }
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
                self.user = appUser
                self.checkUserProfileCompletion(email: email) { isComplete in
                    DispatchQueue.main.async {
                        self.isProfileComplete = isComplete
                    }
                }
                completion(.success(appUser!))
            }
        }
    }


    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isProfileComplete = false
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func checkUserProfileCompletion(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking user profile completion: \(error.localizedDescription)")
                completion(false)
            } else if let document = snapshot?.documents.first {
                let data = document.data()
                let isComplete = (data["email"] as? String != nil)
                print("User profile is complete: \(isComplete)")
                completion(isComplete)
            } else {
                print("No document found for email: \(email)")
                completion(false)
            }
        }
    }

    
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking user existence: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(!(snapshot?.isEmpty ?? true))
            }
        }
    }


    private func convertToAppUser(firebaseUser: FirebaseAuth.User?) -> User? {
        guard let firebaseUser = firebaseUser else { return nil }
        return User(
            id: firebaseUser.uid,
            fullName: firebaseUser.displayName ?? "",
            age: 0,
            email: firebaseUser.email ?? "",
            profileImageURLs: [],
            occupation: nil,
            zodiacSign: nil,
            sexualOrientation: nil,
            userBio: nil,
            matchedLikes: nil
        )
    }
}
