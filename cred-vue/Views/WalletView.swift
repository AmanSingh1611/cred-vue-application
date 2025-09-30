//
//  WalletView.swift
//  cred-vue
//
//  Created by Aman on 30/09/25.
//

import SwiftUI

struct WalletView: View {
    
    // MARK: - Constants
    private enum Constants {
        static let cardTransitionDelay: Double = 0.2
        static let cardOffset: CGFloat = -20
        static let cardOpacity: Double = 0.05
        static let cardShrinkRatio: CGFloat = 0.05
        static let cardRotationAngle: Double = 20
        static let cardScaleWhenDraggingDown: CGFloat = 1.1
        static let padding: CGFloat = 20
    }
    
    // MARK: - Properties
    @EnvironmentObject var wallet: Wallet
    
    @State private var draggingOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var firstCardScale: CGFloat = Constants.cardScaleWhenDraggingDown
    @State private var isPresented: Bool = false
    @State private var shouldDelay: Bool = true
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Background").ignoresSafeArea()
                
                if isPresented {
                    ZStack {
                        ForEach(wallet.cards) { card in
                            CardView(card: card)
                                .opacity(opacity(for: card))
                                .offset(y: offset(for: card))
                                .scaleEffect(scaleEffect(for: card))
                                .rotation3DEffect(rotationAngle(for: card),
                                                  axis: (x: 0.5, y: 1, z: 0))
                                .gesture(dragGesture(for: card, in: geometry))
                                .onTapGesture {
                                    moveCardToTop(card)
                                }
                                //.transition(.moveUpWardsWhileFadingIn)
                                .animation(
                                    .easeOut.delay(transitionDelay(for: card)),
                                    value: wallet.cards
                                )
                        }
                    }
                    .onAppear { shouldDelay = false }
                }
            }
            .onAppear { isPresented.toggle() }
            .padding(.horizontal, Constants.padding)
        }
    }
}

// MARK: - Dragging
private extension WalletView {
    
    private func dragGesture(for card: Card, in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard wallet.isFirst(card: card) else { return }
                draggingOffset = min(50, value.translation.height)
                isDragging = true
            }
            .onEnded { value in
                guard wallet.isFirst(card: card) else { return }
                wallet.cards = cardsResortedAfterTranslation(
                    draggedCard: card,
                    yTranslation: value.translation.height,
                    geometry: geometry
                )
                draggingOffset = 0
                isDragging = false
                withAnimation(.spring()) {
                    firstCardScale = 1.0
                }
            }
    }
}

// MARK: - Helpers
private extension WalletView {
    
    private func moveCardToTop(_ card: Card) {
        wallet.cards = wallet.cards.filter { $0 != card } + [card]
    }
    
    private func cardsResortedAfterTranslation(
        draggedCard card: Card,
        yTranslation: CGFloat,
        geometry: GeometryProxy
    ) -> [Card] {
        if abs(yTranslation + CGFloat(wallet.cards.count) * -Constants.cardOffset) > 15 {
            return [card] + Array(wallet.cards.dropLast())
        }
        return wallet.cards
    }
    
    private func transitionDelay(for card: Card) -> Double {
        guard shouldDelay else { return 0 }
        return Double(wallet.index(of: card)) * Constants.cardTransitionDelay
    }
    
    private func opacity(for card: Card) -> Double {
        let cardIndex = Double(wallet.index(of: card))
        return 1 - cardIndex * Constants.cardOpacity
    }
    
    private func offset(for card: Card) -> CGFloat {
        wallet.isFirst(card: card) ? draggingOffset : CGFloat(wallet.index(of: card)) * Constants.cardOffset
    }
    
    private func scaleEffect(for card: Card) -> CGFloat {
        wallet.isFirst(card: card) ? 1.0 : 1 - CGFloat(wallet.index(of: card)) * Constants.cardShrinkRatio
    }
    
    private func rotationAngle(for card: Card) -> Angle {
        wallet.isFirst(card: card) || isDragging ? .zero : Angle(degrees: Constants.cardRotationAngle)
    }
}

// MARK: - Custom Transition
extension AnyTransition {
    static var moveUpWardsWhileFadingIn: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}


struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView().environmentObject(Wallet(cards: cards))
    }
}
