//
//  Wallet.swift
//  cred-vue
//
//  Created by Aman on 30/09/25.
//

import Foundation
internal import Combine

class Wallet: ObservableObject {
    @Published var cards: [Card]
        
    init(cards: [Card]) {
        self.cards = cards.reversed()
    }
    
    func index(of card: Card) -> Int {
        return cards.count - cards.firstIndex(of: card)! - 1
    }
    
    func isFirst(card: Card) -> Bool {
        return index(of: card) == 0
    }
}
