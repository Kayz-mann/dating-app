//
//  ImageGridView.swift
//  datingApp
//
//  Created by Balogun Kayode on 05/08/2024.
//

import SwiftUI
import PhotosUI

struct ImageGridView: View {
    @Binding var profileImageURLs: [UIImage]
    @State private var showingImagePicker = false
    private let maxImages = 6

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0 ..< maxImages, id: \.self) { index in
                    if index < profileImageURLs.count {
                        Image(uiImage: profileImageURLs[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        AddImageButton()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(images: $profileImageURLs)
        }
    }
    
    @ViewBuilder
    private func AddImageButton() -> some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .frame(width: imageWidth, height: imageHeight)
            
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .foregroundStyle(Color(.primaryPink))
                .offset(x: 4, y: 4)
        }
        .onTapGesture {
            if profileImageURLs.count < maxImages {
                showingImagePicker = true
            }
        }
    }
    
    private var columns: [GridItem] {
        [
            .init(.flexible()),
            .init(.flexible()),
            .init(.flexible())
        ]
    }
    
    private var imageWidth: CGFloat {
        return 110
    }
    
    private var imageHeight: CGFloat {
        return 160
    }
}

#Preview {
    ImageGridView(profileImageURLs: .constant([]))
}
