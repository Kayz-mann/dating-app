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
                        // UI elements for full name, age, profile picture
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
                        
                        AgePicker(selectedAge: $age, validationMessage: $validationMessage)
                            .padding(.top, 35)
                        
                        ImageGridView(profileImageURLs: $profileImageURLs)
                    }
                    .padding()
                }
                
                Spacer()
                
                Button("Next") {
                    currentStep = 2
                // Save to AppState
                appState.currentUser?.fullName = fullName
                appState.currentUser?.age = age
                appState.currentUser?.profileImageURLs = profileImageURLs.map { $0.pngData()?.base64EncodedString() ?? "" }
                }
                
                //OR this
//                profileImageURLs.map { image in
//                    image.pngData()?.base64EncodedString() ?? ""
//                }
                .disabled(!isFormValid)
                .buttonStyle(CustomButtonStyle(isFormValid: isFormValid))
                .padding(.bottom, geometry.safeAreaInsets.bottom) // Add safe area insets padding
            }
        }
        .navigationTitle("Basic Info")
        .foregroundColor(.black)
        .tint(.black)
    }
}




#Preview {
    BasicInfoView(currentStep: .constant(2), profileImageURLs: .constant([]))
}
