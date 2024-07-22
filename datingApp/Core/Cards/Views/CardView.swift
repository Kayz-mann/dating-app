//
//  CardView.swift
//  datingApp
//
//  Created by Balogun Kayode on 22/07/2024.
//

import SwiftUI

struct CardView: View {
    let sizeConstants = SizeConstants()
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    
    @State private var mockImages = [
        "pic1",
        "pic2",
        "pic3",
        "pic4"
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack (alignment: .top) {
                Image(mockImages[currentImageIndex])
                    .resizable()
                    .scaledToFit()
                    .overlay{
                        ImageScrollingView(imageCount: mockImages.count, currentImageIndex: $currentImageIndex)
                    }
                
                SwipeActionIndicatorView(xOffset: $xOffset)

            }
            
            UserInfoView()
                .padding(.horizontal)
        }
        .frame(width: sizeConstants.cardWidth, height: sizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
        DragGesture()
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
        )
    }
}

private extension CardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        
        if abs(width) <= abs(sizeConstants.screenCutOff) {
            xOffset = 0
            degrees = 0
        }
    }
}


#Preview {
    CardView()
}
