//
//  BlockQuoteView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct BlockQuoteView: View {
    @Environment(\.blockQuoteStyle) private var style
    
    let configuration: BlockQuoteConfiguration
    
    init(_ markup: BlockQuote) {
        self.configuration = BlockQuoteConfiguration(markup)
    }
    
    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Style

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

public struct DefaultBlockQuoteStyle: BlockQuoteStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.content
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
        .padding(.leading, 15)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension BlockQuoteStyle where Self == DefaultBlockQuoteStyle {
    public static var `default`: DefaultBlockQuoteStyle {
        DefaultBlockQuoteStyle()
    }
}

// MARK: Environment

extension View {
    public func markdownBlockQuoteStyle<S>(_ style: S) -> some View where S: BlockQuoteStyle {
        environment(\.blockQuoteStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var blockQuoteStyle: any BlockQuoteStyle = DefaultBlockQuoteStyle()
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        > Blockquotes are very handy in email to emulate reply text.
        > This line is part of the same quote.
        
        Quote break.
        
        > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 
        
        > This quote has a quote inside
        >> I'm a quote
        >>
        >> I'm a quote
        """
    }
    .padding()
}
