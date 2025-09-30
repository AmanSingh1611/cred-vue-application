//
//  OnboardingView.swift
//  cred-vue
//
//  Created by Aman on 30/09/25.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    
    // MARK: - Constants
    private enum Constants {
        static let titleWidth: CGFloat = 260
        static let titleFont = "Poppins Bold"
        static let titleSize: CGFloat = 40
        static let descriptionFont = "Inter Regular"
        static let descriptionSize: CGFloat = 25
        static let padding: CGFloat = 40
        static let buttonWidth: CGFloat = 236
        static let buttonHeight: CGFloat = 64
        static let buttonCornerRadius: CGFloat = 30
        static let buttonAnimationDelay: Double = 0.8
        static let dismissThreshold: CGFloat = 120
    }
    
    // MARK: - Properties
    let button = RiveViewModel(fileName: "button", autoPlay: false)
    
    @State private var showModal = false
    @State private var modalDragOffset: CGFloat = 0
    @Binding var show: Bool
    @EnvironmentObject private var appState: AppState
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("Shadow")
                .ignoresSafeArea()
                .opacity(showModal ? 0.4 : 0)
            
            content
                .offset(y: showModal ? -50 : 0)
            
            if showModal {
                modalView
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(1)
            }
        }
    }
}

// MARK: - Subviews
private extension OnboardingView {
    
    var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Welcome to CREDable!")
                .font(.custom(Constants.titleFont, size: Constants.titleSize))
                .frame(width: Constants.titleWidth, alignment: .leading)
            
            Text("Sign in to take control of your credit, stay on top of payments, and enjoy a smarter way to manage money while earning rewards along the way.")
                .font(.custom(Constants.descriptionFont, size: Constants.descriptionSize))
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            startButton
            
            Text("Your data is safe with us. We respect your privacy and ensure secure access to your travel preferences and history.")
                .customFont(.footnote)
                .opacity(0.7)
        }
        .padding(Constants.padding)
        .padding(.top, Constants.padding)
        .background(backgroundLayers)
    }
    
    var startButton: some View {
        button.view()
            .frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
            .background(
                Color.black
                    .cornerRadius(Constants.buttonCornerRadius)
                    .blur(radius: 10)
                    .opacity(0.3)
                    .offset(y: 10)
            )
            .overlay(
                Label("Start The Tour", systemImage: "arrow.forward")
                    .offset(x: 4, y: 4)
                    .customFont(.headline)
                    .accentColor(.primary)
            )
            .onTapGesture {
                button.play(animationName: "active")
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.buttonAnimationDelay) {
                    withAnimation(.spring()) {
                        showModal.toggle()
                    }
                }
            }
    }
    
    var modalView: some View {
        SignInView(show: .constant(true))
            .environmentObject(appState)
            .opacity(showModal ? 1 : 0)
            .offset(y: showModal ? max(0, modalDragOffset) : 300)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            modalDragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > Constants.dismissThreshold {
                            withAnimation(.spring()) {
                                showModal = false
                            }
                        }
                        modalDragOffset = 0
                    }
            )
            .overlay(closeButton, alignment: .bottom)
    }
    
    var closeButton: some View {
        Button {
            withAnimation(.spring()) {
                showModal.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .frame(width: 36, height: 36)
                .foregroundColor(.black)
                .background(.white)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .offset(y: showModal ? 0 : 200)
    }
    
    var backgroundLayers: some View {
        ZStack {
            RiveViewModel(fileName: "shapes").view()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .blur(radius: 30)
                .blendMode(.hardLight)
            
            Image("Spline")
                .blur(radius: 50)
                .offset(x: 200, y: 100)
        }
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(show: .constant(true))
            .environmentObject(AppState())
    }
}
