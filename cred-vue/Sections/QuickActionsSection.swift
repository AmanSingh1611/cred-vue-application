//
//  QuickActionsSection.swift
//  cred-vue
//
//  Created by Aman on 01/10/25.
//

import SwiftUI

struct QuickActionsSection: View {
    let actions: [QuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(actions) { action in
                    QuickActionItem(icon: action.icon, title: action.title)
                }
            }
        }
    }
}

