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
            VStack {
                // UI elements for full name, age, profile picture
                // ...
                
                TextField("Full Name", text: $fullName)
                    .submitLabel(.next)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                           Rectangle()
                               .frame(height: 1)
                               .foregroundColor(.gray)
                               .padding(.top, 35),
                           alignment: .bottom
                       )
                    .frame(height: 50)
                    .padding()
                
                AgePicker(selectedAge: $age, validationMessage: $validationMessage)
                    .padding()
                
                ImageGridView(profileImageURLs: $profileImageURLs)
                    .padding()
                
                Button("Next") {
                    // Save to AppState
                    // appState.currentUser?.fullName = fullName
                    // appState.currentUser?.age = age
                    // appState.currentUser?.profileImageURLs = profileImageURLs
                    currentStep = 2
                }
            }
        }
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

#Preview {
    TellUsMoreView()
        .environmentObject(AppState())
}
