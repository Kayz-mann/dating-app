//
//  CardViewModel.swift
//  datingApp
//
//  Created by Balogun Kayode on 23/07/2024.
//


import Foundation
import Combine
import SwiftUI
import FirebaseAuth




@MainActor
class CardViewModel: ObservableObject {
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction?
    
    private let auth: Auth
    
    private let service: CardService

    init(service: CardService, auth: Auth) {
        self.service = service
        self.auth = auth
        Task { await fetchCardModels() }
    }
    


    func fetchCardModels() async {
        do {
            // Fetch the current user ID from Firebase Authentication
            guard let currentUserId = auth.currentUser?.email else {
                print("DEBUG: Current user ID is not available")
                return
            }
            
            // Fetch card models excluding the current user
            self.cardModels = try await service.fetchCardModel(excluding: currentUserId)
        } catch {
            print("DEBUG: Failed to fetch cards with error \(error)")
        }
    }

    func removeCard(_ card: CardModel) {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000) // Simulate delay
            guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
            cardModels.remove(at: index)
        }
    }
}


//import Foundation
//
////@MainActor
//class CardViewModel: ObservableObject {
//    @Published var cardModels = [CardModel]()
//    @Published var buttonSwipeAction: SwipeAction?
//    
//    private let service: CardService
//    
//    init(service: CardService) {
//        self.service = service
//        Task { await fetchCardModels()}
//    }
//    
//    func fetchCardModels()  async{
//        do {
//            self.cardModels = try await service.fetchCardModels()
//        }catch {
//            print("DEBUG: Failed to fetch cards with error \(error)")
//        }
//    }
//    
//    func removeCard(_ card: CardModel) {
//        Task {
//            try await Task.sleep(nanoseconds: 500_000_000)
//            guard let index = cardModels.firstIndex(where: {$0.id == card.id}) else {return}
//            cardModels.remove(at: index)
//        }
//        
//        //remove card as a collection by index from an array.
//    }
//}
