//
//  CurrentUserProfileView.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            List {
                CurrentUserProfileHeaderView(user: user)
                
                Section("Account Information") {
                    SectionInfo(label: "Name", value: user.fullName)
                    SectionInfo(label: "Email", value: user.email)
                }
                
                Section("Legal") {
                    SectionInfo(label: "Terms of Service")
                }
                
                Section {
                    Button("Logout") {
                        print("DEBUG: Logout here")
                    }
                    .foregroundStyle(.red)
                }
                
                Section {
                    Button("Delete Account") {
                        print("DEBUG: Delete account here")
                    }
                    .foregroundStyle(.red)
                }


                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $showEditProfile) {
                    EditProfileView(user: user)
                }
            }
        }
    }
}

struct SectionInfo: View {
    var label: String
    var value: String?
    
    var body: some View {
        HStack {
            Text(label)
            
            Spacer()
            
            Text(value!)
        }
    }
}

#Preview {
    CurrentUserProfileView(user: MockData.users[0])
}
