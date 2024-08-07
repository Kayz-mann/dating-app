//
//  LoginView.swift
//  datingApp
//
//  Created by Balogun Kayode on 30/07/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var authModel = UserAuthModel()
    @FocusState private var focusTextField: FormTextField?

    @State private var errorMessage: String?
    @State private var alertItem: AlertItem?
    @State private var isLoggedIn = false

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
                        .onSubmit { focusTextField = .password }
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
                        .onSubmit { focusTextField = nil }
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
                    Button(action: {
                        // Validate email and password
                        if authModel.email.isEmpty || authModel.password.isEmpty {
                            alertItem = AlertContext.emptyLoginField
                            return
                        }
                        
                        authService.logIn(email: authModel.email, password: authModel.password) { result in
                            switch result {
                            case .success:
                                // Handle successful log-in
                                isLoggedIn = true
                                break
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                // Display corresponding alert
                                alertItem = AlertContext.firebaseErrorAlert(for: error.localizedDescription)
                            }
                        }
                    }) {
                        Text("Log In")
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
                    .alert(item: $alertItem) { alertItem in
                        Alert(
                            title: alertItem.title,
                            message: alertItem.message,
                            dismissButton: alertItem.dismissButton
                        )
                    }
                    
                    Spacer()
                    Spacer() // Pushes everything up
                }
                
                // Sign Up Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: SignUpView()) {
                            HStack{
                                Text("Sign Up")
                                    .frame(width: 100)
                                    .foregroundColor(.white)
                                    .background(Color.primaryPink)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                Image(systemName: "arrow.right")
                                // SF Symbol for the arrow
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding()
                                
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 0.5)
                            )
                        }
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    LoginView()
}
