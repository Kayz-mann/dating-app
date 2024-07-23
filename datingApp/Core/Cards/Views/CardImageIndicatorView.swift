//
//  CardImageIndicatorView.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import SwiftUI

struct CardImageIndicatorView: View {
    let currentImageIndex: Int
    let imageCount: Int
    let sizeConstants = SizeConstants()

    
    var body: some View {
        HStack{
            ForEach(0 ..< imageCount, id: \.self) {
                index in
                Capsule()
                    .foregroundStyle(currentImageIndex == index ? .white : .gray)
                    .frame(width: imageIndicatorWidth, height: 4)
                    .padding(.top, 8)
            }
        }
    }
}

private extension CardImageIndicatorView {
    var imageIndicatorWidth: CGFloat {
        return sizeConstants.cardWidth / CGFloat(imageCount) - 28
    }
}

#Preview {
    CardImageIndicatorView(currentImageIndex: 1, imageCount: 3)
}
