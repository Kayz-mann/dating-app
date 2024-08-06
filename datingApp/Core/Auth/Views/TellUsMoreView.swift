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
                ForEach(1...2, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentStep ? Color.primaryPink : Color.gray.opacity(0.3))
                        .frame(width: (UIScreen.main.bounds.width - 100) / 2, height: 4)
                }
            }
            .padding(.top)
            .padding(.horizontal, 20)
            
            if currentStep == 1 {
                BasicInfoView(currentStep: $currentStep, profileImageURLs: $profileImageURLs)
            } else if currentStep == 2 {
                AdditionalInfoView(currentStep: $currentStep)
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
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // Add safe area insets padding
                }
            }
            .navigationTitle("Basic Info")
            .font(.subheadline)
            .foregroundColor(.black)
            .tint(.black)
        }
    }
    
    struct AdditionalInfoView: View {
        @Binding var currentStep: Int
        @State private var occupation: String = ""
        @State private var selectedZodiacSign: String = ""
        @State private var sexualOrientation: String = ""
        @State private var isPickerPresented = false
        @State private var validationMessage = ""
        @State private var interestedIn: String = ""
        @State private var isInterestedInPickerPresented = false

        
        
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
                                    isInterestedInPickerPresented.toggle()
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
                                .sheet(isPresented: $isInterestedInPickerPresented) {
                                    VStack {
                                        Picker("Interested In", selection: $interestedIn) {
                                            ForEach(interests, id: \.self) { interest in
                                                Text(interest).tag(interest)
                                            }
                                        }
                                        .labelsHidden()
                                        .pickerStyle(WheelPickerStyle())
                                        
                                        Button("Done") {
                                            isInterestedInPickerPresented = false
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
                    
                    Button("Finish") {
                        
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // Add safe area insets padding
                }
            }
            .navigationTitle("Additional Info")
        }
    }
}



struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
            .foregroundColor(.white)
            .background(Color.primaryPink)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
            .padding(.vertical)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    TellUsMoreView()
        .environmentObject(AppState())
}
