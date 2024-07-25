//
//  UserProfileView.swift
//  datingApp
//
//  Created by Balogun Kayode on 25/07/2024.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentImageIndex = 0
    
    let user: User
    let sizeConstants = SizeConstants()

    
    
    var body: some View {
        VStack {
            HStack {
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(user.age)")
                    .font(.title2)
                
                Spacer()
                
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "arrow.down.circle.fill")
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .foregroundStyle(.primaryPink)
                }
            }
            .padding()
            
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Image(user.profileImageURLs[currentImageIndex])
                            .resizable()
                            .cornerRadius(2)
                            .scaledToFill()
                            .clipped()
                            .frame(width: sizeConstants.cardWidth, height: sizeConstants.cardHeight)
                            .aspectRatio(contentMode: .fill)
                            .overlay{
                                ImageScrollingView(imageCount: user.profileImageURLs.count, currentImageIndex: $currentImageIndex)
                            }
                        
                        CardImageIndicatorView(currentImageIndex:currentImageIndex, imageCount: user.profileImageURLs.count)
                    }
                    
                    VStack(alignment: .leading, spacing: 22) {
                        Text("About me")
                            .fontWeight(.semibold)
                        
                        Text("Some text bio...")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .font(.subheadline)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    Text("Essentials")
                    .fontWeight(.semibold)
                    .padding()
                    
                    VStack {
                        BioData(text: "Woman", imageName: "person")
                        BioData(text: "Straight", imageName: "arrow.down.forward.and.arrow.up.backward.circle")
                        BioData(text: "Entertainment", imageName: "book")

                    }
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                }
            }
        }
    }
}

struct BioData: View {
    let text: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                Image(systemName: imageName)
                Text(text)
                Spacer()
            }
        }
        .padding()
        .font(.subheadline)
    }
}

#Preview {
    UserProfileView(user: MockData.users[0])
}
