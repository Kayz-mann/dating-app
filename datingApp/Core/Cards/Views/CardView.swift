//
//  CardView.swift
//  datingApp
//
//  Created by Balogun Kayode on 22/07/2024.
//

import SwiftUI

struct CardView: View {
    let sizeConstants = SizeConstants()
    let model: CardModel
    
    @ObservedObject var viewModel: CardViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    
//    @State private var mockImages = [
//        "pic1",
//        "pic2",
//        "pic3",
//        "pic4"
//    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack (alignment: .top) {
                Image(user.profileImageURLs[currentImageIndex])
                    .resizable()
                    .cornerRadius(2)
                    .scaledToFill()
                    .clipped()
                    .frame(width: sizeConstants.cardWidth, height: sizeConstants.cardHeight)
                    .aspectRatio(contentMode: .fill)
                    .overlay{
                        ImageScrollingView(imageCount: imageCount, currentImageIndex: $currentImageIndex)
                    }
                
                CardImageIndicatorView(currentImageIndex:currentImageIndex, imageCount: imageCount)
                
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
            
            UserInfoView(user: user)
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
    var user: User {
        return model.user
    }
    
    var imageCount: Int {
        return user.profileImageURLs.count
    }
}

private extension CardView {
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        xOffset = 500
        degrees = 12
        
        viewModel.removeCard(model)
    }
    
    func swipeLeft() {
        xOffset = -500
        degrees = -12
        
        viewModel.removeCard(model)

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
            returnToCenter()
            return
        }
        
        if width >= sizeConstants.screenCutOff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}


#Preview {
    CardView(model: CardModel(user: MockData.users[0]), viewModel:CardViewModel(service: CardService()))
}
