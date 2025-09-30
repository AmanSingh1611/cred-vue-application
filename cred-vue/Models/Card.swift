//
//  Card.swift
//  cred-vue
//
//  Created by Aman on 30/09/25.
//

import Foundation

let cards = [
    Card(number: "4761 \t1200 \t1000 \t0492",
         holderName: "Aman Kumar Singh",
         expiration: "02/22",
         brand: .visa),
    Card(number: "5204 \t2477 \t5000 \t1471",
         holderName: "Aman Kumar Singh",
         expiration: "11/21",
         brand: .mastercard),
    Card(number: "6799 \t9989 \t1234 \t106",
         holderName: "Aman Kumar Singh",
         expiration: "06/20",
         brand: .maestro),
    Card(number: "3499 \t5694 \t5900 \t4136",
         holderName: "Aman Kumar Singh",
         expiration: "03/20",
         brand: .americanExpress)
]

struct Card: Identifiable, Equatable {
    
    static let aspectRatio: Double = 16 / 9
    
    var id: String {
        return number
    }
    
    var number: String
    var holderName: String
    var expiration: String
    var brand: CardBrand
    
}
