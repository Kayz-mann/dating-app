//
//  ChatView.swift
//  datingApp
//
//  Created by Balogun Kayode on 04/09/2024.
//

import SwiftUI

struct ChatView: View {
    let selectedUser: User?
    @State private var messageText = ""
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String?

    var body: some View {
        VStack {
            // Display user details
            HStack {
                if let imageURL = selectedUser?.profileImageURLs.first, let url = URL(string: imageURL) {
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
                    Text(selectedUser?.fullName ?? "")
                        .font(.headline)
//                    if let occupation = selectedUser?.occupation {
//                        Text(occupation)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
                }
                .padding(.leading, 8)
            }
            .padding()

            // Chat Messages
            ScrollView {
                // Example chat bubbles
                VStack(alignment: .leading) {
                    ForEach(sampleMessages) { message in
                        ChatBubble(isCurrentUser: message.isCurrentUser, message: message.text)
                    }
                }
            }

            // Input field for sending a message
            HStack {
                TextField("Enter message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(height: 50) // Increase height for better visibility
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.leading, 8)
                
                Button(action: {
                    // Handle sending message
                    if let emoji = selectedEmoji {
                        messageText += emoji
                        selectedEmoji = nil
                    }
                    // Send the messageText to Firebase or other service
                }) {
                    Text("Send")
                        .padding()
                }
                .padding(.trailing, 8)

                Button(action: {
                    showEmojiPicker.toggle()
                }) {
                    Image(systemName: "face.smiling")
                        .padding()
                }
                .padding(.trailing, 8)
            }
        }
        .padding()
        .navigationTitle("Chat with \(selectedUser?.fullName ?? "Chat")")
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPicker(selectedEmoji: $selectedEmoji)
                .presentationDetents([.height(300)]) // Adjust height as needed
                .shadow(radius: 10)
        }
    }
}

struct ChatBubble: View {
    let isCurrentUser: Bool
    let message: String
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            Text(message)
                .padding()
                .background(isCurrentUser ? Color.blue : Color.pink)
                .foregroundColor(.white)
                .clipShape(ChatBubbleShape(isCurrentUser: isCurrentUser))
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

struct ChatBubbleShape: Shape {
    let isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 16.0
        let arrowWidth: CGFloat = 10.0
        let arrowHeight: CGFloat = 15.0

        if isCurrentUser {
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        } else {
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
            path.addPath(Path(CGRect(x: rect.maxX - arrowWidth - 10, y: rect.midY - arrowHeight / 2, width: arrowWidth, height: arrowHeight)))
        }
        
        return path
    }
}

// Emoji Picker View
struct EmojiPicker: View {
    @Binding var selectedEmoji: String?
    
    let emojis = ["😀", "😂", "😍", "🥺", "😎", "🤔", "🤯", "😜"]

    var body: some View {
        VStack {
            HStack {
                Text("Select an emoji:")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    // Dismiss the picker
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding()
                }
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.largeTitle)
                            .padding()
                            .onTapGesture {
                                selectedEmoji = emoji
                                // Dismiss the picker
                            }
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

// Example data
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
}

let sampleMessages = [
    Message(text: "Hello!", isCurrentUser: true),
    Message(text: "Hi there!", isCurrentUser: false),
    Message(text: "How are you?", isCurrentUser: true)
]
