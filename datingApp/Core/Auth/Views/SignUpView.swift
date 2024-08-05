//
//  SignUpView.swift
//  datingApp
//
//  Created by Balogun Kayode on 03/08/2024.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authService: AuthService
    @State private var authModel = UserAuthModel()
    @FocusState private var focusTextField: FormTextField?

    @State private var errorMessage: String?
    @State private var alertItem: AlertItem?
    @State private var isSignedUp = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.primaryOrange, .pink, .pink, .primaryPink],
                    startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Logo
                    Image(.topLogo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 78, height: 78)
                        .padding(.top, 20)
                    
                    // Text
                    HeadlineTextView()
                    Spacer()
                    
                    // Email and Password Fields
                    TextField("Email", text: $authModel.email)
                        .focused($focusTextField, equals: .email)
                        .onSubmit {focusTextField = .password}
                        .submitLabel(.next)
                    
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .padding(.vertical, 14)
                        .background(
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                        .frame(height: 50)
                        .padding()
                    
                    SecureField("Password", text: $authModel.password)
                        .focused($focusTextField, equals: .password)
                        .onSubmit {focusTextField = nil}
                        .submitLabel(.continue)

                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .padding(.vertical, 14)
                        .background(
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )
                        .frame(height: 50)
                        .padding()
                    
                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Log In Button
                    Button("Sign Up") {
                        //validate email and password
//                        if authModel.email.isEmpty || authModel.password.isEmpty {
//                           return alertItem = AlertContext.emptyLoginField
//                        }
                        
                        isSignedUp = true

                        
//                        authService.signUp(email: authModel.email, password: authModel.password) { result in
//                            switch result {
//                            case .success:
//                                // Handle successful log-in
//                                isSignedUp = true
////                                NavigationLink(<#LocalizedStringKey#>, destination: MainTabView())
//                                
//                                break
//                            case .failure(let error):
//                                errorMessage = error.localizedDescription
//                                // Convert error to ErrorModel and display corresponding alert
//                                let errorModel = error as? ErrorModel ?? .invalidLogin
//                                alertItem = AlertContext.alert(for: errorModel)
//                            }
//                        }
                    }
                    .frame(minWidth: 320)
                    .foregroundColor(.white)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .cornerRadius(20)
                    .padding()
                    .alert(item: $alertItem) {alertItem in
                        Alert(
                            title: alertItem.title,
                            message: alertItem.message,
                            dismissButton: alertItem.dismissButton
                        )
                    }
                    
                    Spacer()
                    Spacer() // Pushes everything up
                }
                
                // Navigation to "Tell Us More About Yourself" screen
                  NavigationLink(
                      destination: TellUsMoreView(),
                      isActive: $isSignedUp
                  ) {
                      EmptyView()
                  }
                
            }
        }
        .tint(.white)

    }
}

#Preview {
    SignUpView()
}
