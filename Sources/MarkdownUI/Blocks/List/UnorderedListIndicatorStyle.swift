//
//  UnorderedListIndicatorStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Style

/// A type that applies a custom style to all unordered lists within a ``MarkdownView``.
@MainActor public protocol UnorderedListIndicatorStyle: Sendable {
    /// A view that represents the body of a unordered list.
    associatedtype Body: View

    /// Creates a view that represents the body of a unordered list.
    ///
    /// The system calls this method for each list instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the unordered list.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the unordered list.
    typealias Configuration = ListIndicatorConfiguration
}

// MARK: - API

extension View {
    /// Sets the style for unordered list indicators within this view.
    ///
    /// - Parameter style: The unordered list indicator style to use for this view.
    public func markdownUnorderedListIndicatorStyle<S>(_ style: S) -> some View where S: UnorderedListIndicatorStyle {
        environment(\.unorderedListIndicatorStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var unorderedListIndicatorStyle: any UnorderedListIndicatorStyle = DefaultUnorderedListIndicatorStyle()
}
