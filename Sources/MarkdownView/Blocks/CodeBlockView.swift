//
//  CodeBlockView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct CodeBlockView: View {
    @Environment(\.codeBlockStyle) private var style
    
    let configuration: CodeBlockConfiguration
    
    init(_ markup: CodeBlock) {
        self.configuration = CodeBlockConfiguration(markup)
    }
    
    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Style

@MainActor public protocol CodeBlockStyle: Sendable {
    associatedtype Body: View

    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = CodeBlockConfiguration
}

public struct CodeBlockConfiguration {
    private let codeBlock: CodeBlock
    
    init(_ codeBlock: CodeBlock) {
        self.codeBlock = codeBlock
    }
    
    public var code: String {
        codeBlock.code
    }
    
    public var language: String? {
        codeBlock.language
    }
}

public struct DefaultCodeBlockStyle: CodeBlockStyle {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    public func makeBody(configuration: Configuration) -> some View {
        #if os(watchOS) || os(tvOS)
        VStack {
            Text(configuration.code.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.caption)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(.secondary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        #else
        GroupBox {
            Text(configuration.code.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.callout)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        #endif
    }
}

public extension CodeBlockStyle where Self == DefaultCodeBlockStyle {
    static var `default`: DefaultCodeBlockStyle {
        DefaultCodeBlockStyle()
    }
}

// MARK: Environment

public extension View {
    func markdownCodeBlockStyle<S>(_ style: S) -> some View where S: CodeBlockStyle {
        environment(\.codeBlockStyle, style)
    }
}

private extension EnvironmentValues {
    @Entry var codeBlockStyle: any CodeBlockStyle = DefaultCodeBlockStyle()
}

// MARK: - Preview

#Preview {
    MarkdownView(
        """
        ```javascript
        var s = "JavaScript syntax highlighting";
        alert(s);
        ```
         
        ```python
        s = "Python syntax highlighting"
        print s
        ```
         
        ```
        No language indicated, so no syntax highlighting. 
        But let's throw in a <b>tag</b>.
        ```
        """
    )
    .padding(.horizontal, 10)
}
