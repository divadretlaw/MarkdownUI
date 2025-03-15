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

@MainActor public protocol BlockQuoteStyle: Sendable {
    associatedtype Body: View

    func makeBody(configuration: Configuration) -> Body
    
    typealias Configuration = BlockQuoteConfiguration
}

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
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
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

public extension BlockQuoteStyle where Self == DefaultBlockQuoteStyle {
    static var `default`: DefaultBlockQuoteStyle {
        DefaultBlockQuoteStyle()
    }
}

// MARK: Environment

public extension View {
    func markdownBlockQuoteStyle<S>(_ style: S) -> some View where S: BlockQuoteStyle {
        environment(\.blockQuoteStyle, style)
    }
}

private extension EnvironmentValues {
    @Entry var blockQuoteStyle: any BlockQuoteStyle = DefaultBlockQuoteStyle()
}

// MARK: - Preview

#Preview {
    MarkdownView(
    """
    > Blockquotes are very handy in email to emulate reply text.
    > This line is part of the same quote.

    Quote break.

    > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 
    
    > This quote has a quote inside
    >> I'm a quote
    """
    )
    .padding()
}
