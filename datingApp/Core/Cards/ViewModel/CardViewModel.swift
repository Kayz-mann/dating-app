//
//  CardViewModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//

import Foundation

//@MainActor
class CardViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    
    private let service: CardService
    
    init(service: CardService) {
        self.service = service
        Task { await fetchCardModels()}
    }
    
    func fetchCardModels()  async{
        do {
            self.cardModels = try await service.fetchCardModels()
        }catch {
            print("DEBUG: Failed to fetch cards with error \(error)")
        }
    }
    
    func removeCard(_ card: CardModel) {
        guard let index = cardModels.firstIndex(where: {$0.id == card.id}) else {return}
        cardModels.remove(at: index)
        
        //remove card as a collection by index from an array.
    }
}
