//
//  ScreenSize.swift
//  Challenge2
//
//  The shape of the space the app is drawn in, worked out once from the size classes
//  and handed to every view through the environment as `\.screenSize`.
//

import SwiftUI

enum ScreenSize {
    /// A full iPad screen (regular width and height): the layout the app was designed for.
    case regular
    /// Narrow and tall, like an iPhone held upright.
    case phonePortrait
    /// Wide but short, like an iPhone on its side.
    case phoneLandscape

    init(horizontal: UserInterfaceSizeClass?, vertical: UserInterfaceSizeClass?) {
        switch (horizontal, vertical) {
        case (_, .compact):
            // Short height: an iPhone on its side.
            self = .phoneLandscape
        case (.compact, _):
            // Narrow width: an iPhone upright, or a narrow iPad window (Slide Over / Stage Manager).
            self = .phonePortrait
        default:
            // Regular on both, or unknown: assume the full iPad layout.
            self = .regular
        }
    }

    /// Anything smaller than a full iPad screen.
    var isCompact: Bool { self != .regular }
    var isPhonePortrait: Bool { self == .phonePortrait }
    var isPhoneLandscape: Bool { self == .phoneLandscape }

    /// Picks the number that fits this screen.
    func value(regular: CGFloat, portrait: CGFloat, landscape: CGFloat) -> CGFloat {
        switch self {
        case .regular: regular
        case .phonePortrait: portrait
        case .phoneLandscape: landscape
        }
    }

    /// The one mascot size every game screen uses.
    var mascotHeight: CGFloat { value(regular: 200, portrait: 110, landscape: 80) }
}

extension EnvironmentValues {
    @Entry var screenSize: ScreenSize = .regular
}

/// Reads the size classes and passes the matching `ScreenSize` down to every view inside.
private struct ScreenSizeProvider: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontal
    @Environment(\.verticalSizeClass) private var vertical

    func body(content: Content) -> some View {
        content.environment(\.screenSize, ScreenSize(horizontal: horizontal, vertical: vertical))
    }
}

extension View {
    /// Apply once at the root of the app.
    func providesScreenSize() -> some View {
        modifier(ScreenSizeProvider())
    }
}
