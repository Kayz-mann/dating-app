//
//  ImageScrollingView.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import SwiftUI

struct ImageScrollingView: View {
    let imageCount: Int
    @Binding var currentImageIndex: Int
    
    var body: some View {
        HStack {
            Rectangle()
                .onTapGesture {
                    updateImageIndex(increment: false)
                }
            
            Rectangle()
                .onTapGesture {
                    updateImageIndex(increment: true)
                }
        }
        .foregroundColor(.red.opacity(0.01))
    }
}

private extension ImageScrollingView {
    func updateImageIndex(increment: Bool) {
        if increment {
            guard currentImageIndex < imageCount - 1 else {return}
            currentImageIndex += 1
        } else {
            guard currentImageIndex > 0 else {return}
            currentImageIndex -= 1
        }
    }
}

#Preview {
    ImageScrollingView(imageCount: 2, currentImageIndex: .constant(1))
}
