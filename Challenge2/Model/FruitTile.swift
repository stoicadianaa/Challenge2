//
//  FruitTile.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import SwiftUI

struct FruitTile: View {

    static let coordinateSpace = "fruitDrag"

    let fruit: FruitItem
    let isSolved: Bool                       // the game is solved
    let isTarget: Bool                       // this is the right fruit
    let onMove: (CGPoint) -> Void            // finger position while dragging
    let onDrop: (CGPoint) -> Bool            // true = right fruit, false = it comes back
    let onChoose: () -> Void                 // VoiceOver: double tap instead of dragging

    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Text(fruit.emoji)
            .padding(24)
            .glassEffect(.regular, in: .circle)
            .offset(offset)
            .scaleEffect(scale)
            .opacity(opacity)
            .zIndex(isDragging ? 1 : 0)     // while dragging it goes above the other fruits
            .gesture(drag)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
            .animation(.easeOut(duration: 0.4), value: isSolved)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(fruit.name)
            .accessibilityHint("Drag it onto the letter, or double tap to choose it")
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { onChoose() }
    }

    // The right fruit shrinks and disappears on the letter, the others step back
    private var scale: CGFloat {
        if isSolved && isTarget { return 0.55 }
        return isDragging ? 1.12 : 1
    }

    private var opacity: Double {
        guard isSolved else { return 1 }
        return isTarget ? 0 : 0.55
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named(Self.coordinateSpace))
            .onChanged { value in
                guard !isSolved else { return }
                isDragging = true
                offset = value.translation
                onMove(value.location)
            }
            .onEnded { value in
                isDragging = false
                guard !isSolved else { return }

                // Wrong place or wrong fruit: back to where it was, with a bounce
                if !onDrop(value.location) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.5)) {
                        offset = .zero
                    }
                }
            }
    }
}
