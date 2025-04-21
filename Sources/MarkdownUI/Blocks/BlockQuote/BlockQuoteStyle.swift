//
//  BlockQuoteStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI
import Markdown

// MARK: - Style

/// The properties of the block quote.
public struct BlockQuoteConfiguration {
    private let quote: BlockQuote

    init(_ quote: BlockQuote) {
        self.quote = quote
    }

    @MainActor public var content: some View {
        MarkupView(quote)
    }
}
/// A type that applies a custom style to all block quotes within a ``MarkdownView``.
@MainActor public protocol BlockQuoteStyle: Sendable {
    /// A view that represents the body of a block quote.
    associatedtype Body: View

    /// Creates a view that represents the body of a block quote.
    ///
    /// The system calls this method for each block quote instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the block quote.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the block quote.
    typealias Configuration = BlockQuoteConfiguration
}

// MARK: - API

extension View {
    public func markdownBlockQuoteStyle<S>(_ style: S) -> some View where S: BlockQuoteStyle {
        environment(\.blockQuoteStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var blockQuoteStyle: any BlockQuoteStyle = DefaultBlockQuoteStyle()
}
