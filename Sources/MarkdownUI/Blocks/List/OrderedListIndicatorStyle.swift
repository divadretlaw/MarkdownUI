//
//  OrderedListIndicatorStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Style

/// A type that applies a custom style to all ordered lists within a ``MarkdownView``.
@MainActor public protocol OrderedListIndicatorStyle: Sendable {
    /// A view that represents the body of a list.
    associatedtype Body: View

    /// Creates a view that represents the body of a ordered list.
    ///
    /// The system calls this method for each list instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the ordered list.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the ordered list.
    typealias Configuration = ListIndicatorConfiguration
}

// MARK: - API

extension View {
    /// Sets the style for ordered list indicators within this view.
    ///
    /// - Parameter style: The ordered list indicator style to use for this view.
    public func markdownOrderedListIndicatorStyle<S>(_ style: S) -> some View where S: OrderedListIndicatorStyle {
        environment(\.orderedListIndicatorStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var orderedListIndicatorStyle: any OrderedListIndicatorStyle = DefaultOrderedListIndicatorStyle()
}
