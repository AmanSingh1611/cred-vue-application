//
//  QuickActionItem.swift
//  cred-vue
//
//  Created by Aman on 01/10/25.
//

import SwiftUI

struct QuickActionItem: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color("Background 2").opacity(0.8))
                .customFont(.title2)
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.12))
                .clipShape(Circle())

            Text(title)
                .customFont(.caption2)
                .multilineTextAlignment(.center)
        }
    }
}

