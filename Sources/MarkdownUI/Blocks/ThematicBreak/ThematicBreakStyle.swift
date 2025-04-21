//
//  ThematicBreakStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Style

/// The properties of the thematic break.
public struct ThematicBreakConfiguration {}

/// A type that applies a custom style to all thematic breaks within a ``MarkdownView``.
@MainActor public protocol ThematicBreakStyle: Sendable {
    /// A view that represents the body of a thematic break.
    associatedtype Body: View

    /// Creates a view that represents the body of a thematic break.
    ///
    /// The system calls this method for each thematic break instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the thematic break.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the thematic break.
    typealias Configuration = ThematicBreakConfiguration
}

// MARK: - API

extension View {
    public func markdownThematicBreakStyle<S>(_ style: S) -> some View where S: ThematicBreakStyle {
        environment(\.thematicBreakStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var thematicBreakStyle: any ThematicBreakStyle = DefaultThematicBreakStyle()
}
