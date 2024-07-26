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
    @State private var showProfileModal = false
    @EnvironmentObject var matchManager : MatchManager

    
//    @State private var mockImages = [
//        "pic1",
//        "pic2",
//        "pic3",
//        "pic4"
//    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack (alignment: .top) {
                ImageLoader(url:  URL(string: user.profileImageURLs[currentImageIndex]), placeholder: Image(systemName: "photo"), errorImage: Image(systemName: "photo"), size: CGSize(width: sizeConstants.cardWidth, height: sizeConstants.cardHeight))
                    .overlay{
                        ImageScrollingView(imageCount: imageCount, currentImageIndex: $currentImageIndex)
                    }
                
                CardImageIndicatorView(currentImageIndex:currentImageIndex, imageCount: imageCount)
                
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
            
            UserInfoView(user: user, showProfileModal: $showProfileModal)
                .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showProfileModal) {
            UserProfileView(user: user)
        }
        .onReceive(viewModel.$buttonSwipeAction, perform: {action in
        onReceiveSwipeAction(action)})
        
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
        withAnimation{
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.removeCard(model)
            matchManager.checkForMatch(withUser: user)
        }
    }
    
    func swipeLeft() {
        withAnimation{
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.removeCard(model)
        }

    }
    
    func onReceiveSwipeAction(_ action: SwipeAction?) {
        guard let action else { return }
        
        let topCard = viewModel.cardModels.last
        
        if topCard == model {
            switch action {
            case .reject:
                swipeLeft()
            case .like:
                swipeRight()
            }
        }
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
