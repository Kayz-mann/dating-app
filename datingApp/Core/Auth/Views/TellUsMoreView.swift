//
//  TellUsMoreView.swift
//  datingApp
//
//  Created by Balogun Kayode on 05/08/2024.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var currentUser: User?
}

struct TellUsMoreView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 1
    @State private var profileImageURLs: [UIImage] = []

    var body: some View {
        VStack {
            // Step Indicator
            HStack {
                ForEach(1...3, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentStep ? Color.primaryPink : Color.gray.opacity(0.3))
                        .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 4)
                }
            }
            .padding(.top)
            .padding(.horizontal, 20)
            
            if currentStep == 1 {
                BasicInfoView(currentStep: $currentStep, profileImageURLs: $profileImageURLs)
            } else if currentStep == 2 {
                AdditionalInfoView(currentStep: $currentStep)
            } else if currentStep == 3 {
                PreferencesView(currentStep: $currentStep)
            }
        }
    }
}

struct BasicInfoView: View {
    @EnvironmentObject var appState: AppState
    @Binding var currentStep: Int
    @State private var fullName: String = ""
    @State private var age: Int = 18
    @Binding var profileImageURLs: [UIImage]
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                VStack {
                    // UI elements for full name, age, profile picture
                    VStack(alignment: .leading) {
                        Text("Enter Full Name")
                            .font(.footnote)
                        
                        TextField("Full Name", text: $fullName)
                            .submitLabel(.next)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray),
                                alignment: .bottom
                            )
                            .frame(height: 25)
                    }
                    .padding(.top, 25)
                    
                    
                    AgePicker(selectedAge: $age, validationMessage: $validationMessage)
                        .padding(.top, 35)
                    
                    ImageGridView(profileImageURLs: $profileImageURLs)
                      
                    
                    Button("Next") {
                        // Save to AppState
                        // appState.currentUser?.fullName = fullName
                        // appState.currentUser?.age = age
                        // appState.currentUser?.profileImageURLs = profileImageURLs
                        currentStep = 2
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                .padding()
                
            }
        }
        .navigationTitle("Basic Info")
        .font(.subheadline)
        .foregroundColor(.black)
        .tint(.black)
    }
}

struct AdditionalInfoView: View {
    @EnvironmentObject var appState: AppState
    @Binding var currentStep: Int
    @State private var occupation: String = ""
    @State private var zodiacSign: String = ""
    @State private var sexualOrientation: String = ""
    @State private var userBio: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // UI elements for occupation, zodiac sign, sexual orientation, user bio
                    // ...
                    Text("Step 2")
                    Button("Next") {
                        // Save to AppState
                        // appState.currentUser?.occupation = occupation
                        // appState.currentUser?.zodiacSign = zodiacSign
                        // appState.currentUser?.sexualOrientation = sexualOrientation
                        // appState.currentUser?.userBio = userBio
                        currentStep = 3
                    }
                }
            }
        }
        .tint(.black)
    }
}

struct PreferencesView: View {
    @EnvironmentObject var appState: AppState
    @Binding var currentStep: Int
    @State private var interestedIn: String = ""
    // Other preference fields...

    var body: some View {
        NavigationStack {
            VStack {
                // UI elements for interestedIn and other preferences
                // ...
                Text("Step 3")
                Button("Finish") {
                    // Save to AppState
                    // appState.currentUser?.interestedIn = interestedIn
                    // Call function to save data to Firebase
                    // saveToFirebase()
                }
            }
        }
        .tint(.black)
    }

    func saveToFirebase() {
        // Implement Firebase save logic here
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50) // Fixed height for consistency
            .foregroundColor(.white) // Text color
            .background(Color.primaryPink) // Background color
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2) // Optional shadow
            .padding(.vertical) // Vertical padding
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Scale effect on press
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed) // Animation
    }
}

#Preview {
    TellUsMoreView()
        .environmentObject(AppState())
}
