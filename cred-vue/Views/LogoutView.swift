//
//  LogoutView.swift
//  cred-vue
//
//  Created by Aman on 01/10/25.
//

import SwiftUI
import RiveRuntime

struct LogoutView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    @State private var animateCard = false
    
    let logoutIcon = RiveViewModel(fileName: "logout_icon")
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                logoutIcon.view()
                    .frame(width: 80, height: 80)
                    .padding(.top, 10)
                
                Text("Log Out")
                    .customFont(.headline)
                    .foregroundColor(.primary)
                
                Text("Are you sure you want to log out of your account?")
                    .customFont(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                HStack(spacing: 15) {
                    Button("Cancel") {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    }
                    .customFont(.bodyLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button("Log Out") {
                        appState.isLoggedIn = false
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    }
                    .customFont(.bodyLarge)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 227/255, green: 114/255, blue: 89/255))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .frame(maxWidth: 320)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 20)
            .scaleEffect(animateCard ? 1 : 0.8)
            .opacity(animateCard ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    animateCard = true
                }
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LogoutView(isPresented: .constant(true))
        }
    }
}
