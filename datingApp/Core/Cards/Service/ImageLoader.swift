//
//  ImageLoader.swift
//  datingApp
//
//  Created by Balogun Kayode on 26/07/2024.
//

import SwiftUI

struct ImageLoader: View {
    let url: URL?
    let placeholder: Image
    let errorImage: Image
    let size: CGSize
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                case .success(let image):
                    image
                        .resizable()
                        .cornerRadius(2)
                        .scaledToFill()
                        .clipped()
                        .frame(width: size.width, height: size.height)
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    errorImage
                        .resizable()
                        .cornerRadius(2)
                        .scaledToFit()
                        .frame(width: size.width, height: size.height)
                        .aspectRatio(contentMode: .fit)
                    
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            errorImage
                .resizable()
                .cornerRadius(2)
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .aspectRatio(contentMode: .fit)
        }
    }

}

#Preview {
    ImageLoader(url: URL(string: "https://images.pexels.com/photos/388517/pexels-photo-388517.jpeg?auto=compress&cs=tinysrgb&w=800"), placeholder: Image(systemName: "photo"), errorImage: Image(systemName: "photo"), size: CGSize(width: 100, height: 150)
    )
}
