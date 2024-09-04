//
//  CurrentUserProfileView.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject private var viewModel = CurrentUserViewModel()
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            Group {
                if let user = viewModel.user {
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
                                // Handle logout
                                print("DEBUG: Logout here")
                            }
                            .foregroundStyle(.red)
                        }
                        
                        Section {
                            Button("Delete Account") {
                                // Handle account deletion
                                print("DEBUG: Delete account here")
                            }
                            .foregroundStyle(.red)
                        }
                    }
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .fullScreenCover(isPresented: $showEditProfile) {
                        EditProfileView(user: user)
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            viewModel.fetchCurrentUser()
                        }
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
            
            Text(value ?? "Not available")
                .foregroundColor(value == nil ? .gray : .primary)
        }
    }
}

// Assuming CurrentUserProfileHeaderView and EditProfileView are defined elsewhere
#Preview {
    CurrentUserProfileView()
}
