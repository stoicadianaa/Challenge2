//
//  ScrollIfNeeded.swift
//  Challenge2
//
//  Shows its content at its natural height, centered by the parent, and only
//  scrolls when there isn't enough room (a small window, or the keyboard is up).
//

import SwiftUI

struct ScrollIfNeeded<Content: View>: View {
    @ViewBuilder let content: Content

    /// The content's natural height; nil until it has been measured once.
    @State private var contentHeight: CGFloat?

    var body: some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { contentHeight = $0 }
        }
        // Never taller than the content, so it hugs it; smaller when the space is smaller.
        .frame(maxHeight: contentHeight)
        // No rubber-band bounce while everything fits.
        .scrollBounceBehavior(.basedOnSize)
    }
}
