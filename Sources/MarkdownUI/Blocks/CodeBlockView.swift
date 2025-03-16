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

/// A type that applies a custom style to all code blocks within a ``MarkdownView``.
@MainActor public protocol CodeBlockStyle: Sendable {
    /// A view that represents the body of a code block.
    associatedtype Body: View

    /// Creates a view that represents the body of a code block.
    ///
    /// The system calls this method for each code block instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the code block.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
    
    /// The properties of the code block.
    typealias Configuration = CodeBlockConfiguration
}

/// The properties of the code block.
public struct CodeBlockConfiguration {
    private let codeBlock: CodeBlock
    
    init(_ codeBlock: CodeBlock) {
        self.codeBlock = codeBlock
    }
    
    public var code: String {
        guard codeBlock.code.hasSuffix("\n") else {
            return codeBlock.code
        }
        return String(codeBlock.code.dropLast())
    }
    
    public var language: String? {
        codeBlock.language
    }
}

public struct DefaultCodeBlockStyle: CodeBlockStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        #if os(watchOS) || os(tvOS)
        VStack {
            Text(configuration.code)
                .font(.caption)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(.secondary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        #else
        GroupBox {
            Text(configuration.code)
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

extension EnvironmentValues {
    @Entry var codeBlockStyle: any CodeBlockStyle = DefaultCodeBlockStyle()
}

// MARK: - Preview

#Preview {
    MarkdownView {
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
    }
    .padding()
}
