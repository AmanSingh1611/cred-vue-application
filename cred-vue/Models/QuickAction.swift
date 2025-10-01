//
//  QuickAction.swift
//  cred-vue
//
//  Created by Aman on 01/10/25.
//

import Foundation

struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

extension QuickAction {
    static let sampleData: [QuickAction] = [
        QuickAction(icon: "arrow.up.right.circle", title: "Pay to UPI ID"),
        QuickAction(icon: "person.2.fill", title: "Pay to Contacts"),
        QuickAction(icon: "phone.fill", title: "Pay to Phone"),
        QuickAction(icon: "arrow.left.arrow.right", title: "Bank Transfer"),
        QuickAction(icon: "doc.text", title: "Pay Bills"),
        QuickAction(icon: "bolt.fill", title: "Mobile Recharge")
    ]
}

