//
//  CardStackView.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import SwiftUI

struct CardStackView: View {
    @StateObject var viewModel = CardViewModel(service: CardService())
    
    var body: some View {
        ZStack {
            ForEach(viewModel.cardModels) {card in
                CardView(model: card, viewModel: viewModel)
            }
        }
        .onChange(of: viewModel.cardModels, {
            oldValue, newValue in 
            print("DEBUG: Old value count is \(oldValue.count)")
            print("DEBUG: New value count is \(newValue.count)")

        })
    }
}

#Preview {
    CardStackView()
}
