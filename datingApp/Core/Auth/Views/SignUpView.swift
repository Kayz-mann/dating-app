import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authService: AuthService
    @State private var authModel = UserAuthModel()
    @FocusState private var focusTextField: FormTextField?

    @State private var errorMessage: String?
    @State private var alertItem: AlertItem?
    @State private var isSignedUp = false
    @State private var isLoading = false
    
    @State private var navigateToTellUsMore = false

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
                    
                    // Sign Up Button
                    Button(action: {
                        signUp()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
                            }
                        }
                    }
                    .frame(minWidth: 320)
                    .foregroundColor(.white)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding()
                    .disabled(isLoading || !isFormValid) // Disable button when loading or form is invalid
                    
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
                
                // Navigation to "Tell Us More About Yourself" screen
                NavigationLink(
                    destination: TellUsMoreView(),
                    isActive: $navigateToTellUsMore
                ) {
                    EmptyView()
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !authModel.email.isEmpty && !authModel.password.isEmpty
    }
    
    private func signUp() {
        // Show loading spinner
        isLoading = true
        
        // Validate email and password
        if authModel.email.isEmpty || authModel.password.isEmpty {
            isLoading = false
            alertItem = AlertContext.emptyLoginField
            return
        }
        
        // Save to appState
        appState.currentUser?.email = authModel.email
        
        // Sign up process
        authService.signUp(email: authModel.email, password: authModel.password) { result in
            switch result {
            case .success:
                // Handle successful sign-up
                isSignedUp = true
                navigateToTellUsMore = true
                print("Sign-up successful", result)
                
            case .failure(let error):
                // Handle sign-up failure
                errorMessage = error.localizedDescription
                print("Sign-up failed: \(error.localizedDescription)")
                // Convert error to ErrorModel and display corresponding alert
                let errorModel = error as? ErrorModel ?? .invalidLogin
                alertItem = AlertContext.alert(forMessage: error.localizedDescription)
            }
            // Hide loading spinner
            isLoading = false
        }
    }
}

#Preview {
    SignUpView()
}
