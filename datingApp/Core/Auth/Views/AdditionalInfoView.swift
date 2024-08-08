//
//  AditionalInfoView.swift
//  datingApp
//
//  Created by Balogun Kayode on 06/08/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AdditionalInfoView: View {
    @Binding var currentStep: Int
    @State private var occupation: String = ""
    @State private var selectedZodiacSign: String = ""
    @State private var sexualOrientation: String = ""
    @State private var interestedIn: String = ""
    @State private var isPickerPresented = false
    @State private var isInterestPickerPresented = false
    @State private var validationMessage = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var isLoggedIn = false
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var appState: AppState
    private let db = Firestore.firestore()
    
    private var isFormValid: Bool {
        !occupation.isEmpty &&
        !selectedZodiacSign.isEmpty &&
        !sexualOrientation.isEmpty &&
        !interestedIn.isEmpty
    }

    private let sexualOrientations = ["Straight", "Bi"]
    private let interests = ["Male", "Female"]
    private let zodiacSigns = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        // Occupation
                        VStack(alignment: .leading) {
                            Text("Occupation")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            TextField("Enter your occupation", text: $occupation)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.top, 25)
                        
                        // Zodiac Sign
                        VStack(alignment: .leading) {
                            Text("Zodiac Sign")
                                .font(.footnote)
                                .padding(.top)
                                .padding(.bottom)
                            
                            // Zodiac Sign Selection
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(zodiacSigns, id: \.self) { sign in
                                    Text(sign)
                                        .font(.footnote)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 6)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(sign == selectedZodiacSign ? Color.primaryPink : Color.gray.opacity(0.2))
                                        )
                                        .foregroundColor(sign == selectedZodiacSign ? .white : .black)
                                        .onTapGesture {
                                            selectedZodiacSign = sign
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom)
                        
                        // Sexual Orientation Picker
                        VStack(alignment: .leading) {
                            Text("Sexual Orientation")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            Button(action: {
                                isPickerPresented.toggle()
                            }) {
                                HStack {
                                    Text(sexualOrientation.isEmpty ? "Sexual orientation" : sexualOrientation)
                                        .foregroundColor(sexualOrientation.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $isPickerPresented) {
                                VStack {
                                    Picker("Sexual Orientation", selection: $sexualOrientation) {
                                        ForEach(sexualOrientations, id: \.self) { orientation in
                                            Text(orientation).tag(orientation)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Button("Done") {
                                        isPickerPresented = false
                                    }
                                    .padding()
                                }
                                .padding()
                            }
                        }
                        .padding(.top, 35)
                        
                        // Interest Picker
                        VStack(alignment: .leading) {
                            Text("Interested In")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            Button(action: {
                                isInterestPickerPresented.toggle()
                            }) {
                                HStack {
                                    Text(interestedIn.isEmpty ? "Interested In" : interestedIn)
                                        .foregroundColor(interestedIn.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $isInterestPickerPresented) {
                                VStack {
                                    Picker("Interested In", selection: $interestedIn) {
                                        ForEach(interests, id: \.self) { interest in
                                            Text(interest).tag(interest)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Button("Done") {
                                        isInterestPickerPresented = false
                                    }
                                    .padding()
                                }
                                .padding()
                            }
                        }
                        .padding(.top, 35)
                        
                        // Validation Message
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    updateProfile()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Finish")
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle(isFormValid: isFormValid))
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
                }
                
                // Navigation Link
                NavigationLink(
                    destination: MainTabView()
                        .navigationBarBackButtonHidden(true) // Hide the back button
                        .navigationBarTitleDisplayMode(.inline)
                     
                    , // Ensure no title display
                    isActive: $authService.isProfileComplete,
                    label: { EmptyView() }
                )
            }
        }
        .navigationTitle("Additional Info")
    }

    private func updateProfile() {
        guard isFormValid else {
            validationMessage = "Please complete all fields."
            showingAlert = true
            isLoading = false
            return
        }
        
        isLoading = true

        // Retrieve information from AppState
        guard let email = appState.currentUser?.email,
              let fullName = appState.currentUser?.fullName,
              let age = appState.currentUser?.age, !email.isEmpty else {
            validationMessage = "Required user data is missing or email is empty."
            showingAlert = true
            isLoading = false
            return
        }

        // Update or create profile information in Firestore
        let userRef = db.collection("users").document(email)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update it
                userRef.updateData([
                    "occupation": occupation,
                    "zodiacSign": selectedZodiacSign,
                    "sexualOrientation": sexualOrientation,
                    "interestedIn": interestedIn,
                    "email": email,
                    "fullName": fullName,
                    "age": age
                ]) { error in
                    isLoading = false
                    if let error = error {
                        validationMessage = "Error updating profile: \(error.localizedDescription)"
                        showingAlert = true
                    } else {
                        // Proceed to next step if successful
                        authService.isProfileComplete = true
                        isLoggedIn = true
                        print("Profile updated, isProfileComplete set to true")
                    }
                }
            } else {
                // Document does not exist, create it
                userRef.setData([
                    "occupation": occupation,
                    "zodiacSign": selectedZodiacSign,
                    "sexualOrientation": sexualOrientation,
                    "interestedIn": interestedIn,
                    "email": email,
                    "fullName": fullName,
                    "age": age
                ]) { error in
                    isLoading = false
                    if let error = error {
                        validationMessage = "Error creating profile: \(error.localizedDescription)"
                        showingAlert = true
                    } else {
                        // Proceed to next step if successful
                        authService.isProfileComplete = true
                        isLoggedIn = true
                        print("Profile created, isProfileComplete set to true")
                    }
                }
            }
        }
    }
}


struct CustomButtonStyle: ButtonStyle {
    var isFormValid: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .foregroundColor(isFormValid ? .white : .gray)
            .background(isFormValid ? Color.primaryPink : Color.primaryDisabled)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
            .padding(.vertical)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    AdditionalInfoView(currentStep: .constant(2))
        .environmentObject(AuthService())
        .environmentObject(AppState())
}
