//
//  BasicInfoView.swift
//  datingApp
//
//  Created by Balogun Kayode on 06/08/2024.
//

import SwiftUI

struct BasicInfoView: View {
    @EnvironmentObject var appState: AppState
    @Binding var currentStep: Int
    @State private var fullName: String = ""
    @State private var age: Int = 18
    @Binding var profileImageURLs: [UIImage]
    @State private var validationMessage = ""
    @State private var gender = ""
    @State private var genderPickerPresented = false

    private let genderOption = ["Male", "Female"]
    
    private var isFormValid: Bool {
        !fullName.isEmpty &&
        (age >= 18 && age <= 120) &&
        !profileImageURLs.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView (showsIndicators: false) {
                    VStack {
                        // Full Name Input
                        VStack(alignment: .leading) {
                            Text("Full Name")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            TextField("Enter your Full Name", text: $fullName)
                                .padding()
                                .font(.footnote)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.top, 10)
                        
                        // Age Picker
                        AgePicker(selectedAge: $age, validationMessage: $validationMessage)
                            .padding(.top, 8)
                        
                        //Gender Picker
                        CustomPicker(value: $gender, label: "Gender", data: genderOption)
                
                        // Profile Image Grid
                        ImageGridView(profileImageURLs: $profileImageURLs)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Next Button
                Button("Next") {
                    if isFormValid {
                        // Save to AppState
                        appState.currentUser?.fullName = fullName
                        appState.currentUser?.age = age
                        appState.currentUser?.gender = gender
                        appState.currentUser?.profileImageURLs = profileImageURLs.map { $0.pngData()?.base64EncodedString() ?? "" }
                        
                        // Move to next step
                        currentStep = 2
                    } else {
                        validationMessage = "Please fill out all fields correctly."
                    }
                }
                .disabled(!isFormValid)
                .buttonStyle(CustomButtonStyle(isFormValid: isFormValid))
                .padding(.bottom, geometry.safeAreaInsets.bottom) // Add safe area insets padding
            }
        }
        .navigationTitle("Basic Info")
        .foregroundColor(.black)
        .tint(.black)
        .alert(isPresented: Binding<Bool>(
            get: { !validationMessage.isEmpty },
            set: { _ in validationMessage = "" }
        )) {
            Alert(title: Text("Validation Error"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    var isFormValid: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50) // Set button width and height
            .foregroundColor(isFormValid ? .white : .gray) // Text color based on form validity
            .background(isFormValid ? Color.primaryPink : Color.primaryDisabled) // Background color based on form validity
            .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2) // Shadow effect
            .padding(.vertical) // Vertical padding
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Scale effect on press
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed) // Animation effect
    }
}

#Preview {
    BasicInfoView(currentStep: .constant(2), profileImageURLs: .constant([]))
}
