//
//  SwiftUIView.swift
//  datingApp
//
//  Created by Balogun Kayode on 04/09/2024.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var matchManager: MatchManager
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search by name", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 20)

                // List of Matched Users
                ScrollView {
                    ForEach(filteredUsers) { user in
                        NavigationLink(destination: ChatView(selectedUser: user)) {
                            HStack {
                                if let imageURL = user.profileImageURLs.first, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(width: 50, height: 50)
                                             .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 50, height: 50)
                                }

                                VStack(alignment: .leading) {
                                    Text(user.fullName)
                                        .font(.headline)
                                    if let occupation = user.occupation {
                                        Text(occupation)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.leading, 8)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Search Matches")
            .onAppear {
                matchManager.fetchMatchedUsers()
            }
        }
    }
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return matchManager.matchedUsers
        } else {
            return matchManager.matchedUsers.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
}
