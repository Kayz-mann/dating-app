//
//  TellUsMoreView.swift
//  datingApp
//
//  Created by Balogun Kayode on 05/08/2024.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var currentUser: User? = User(
        id: nil,
        fullName: "",
        age: 18,
        email: "",
        profileImageURLs: [],
        occupation: nil,
        zodiacSign: nil,
        sexualOrientation: nil,
        userBio: nil,
        matchedLikes: nil,
        interestedIn: nil,
        matchedUsers: nil,
        likedUsers: nil
    )
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
}






#Preview {
    TellUsMoreView()
        .environmentObject(AppState())
}
