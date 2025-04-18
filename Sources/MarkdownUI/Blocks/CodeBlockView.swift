//
//  CodeBlockView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown
#if !os(watchOS)
import HighlightJS
import HighlightUI
#endif

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
        #if !os(watchOS)
        CodeBox(configuration.code, language: language(configuration: configuration))
            .font(.callout)
            .codeStyle(Style(".hljs{color:#E7E8EB;background:#292A2F}.hljs ::selection,.hljs::selection{background-color:#363945}.hljs-formula,.hljs-params,.hljs-property{}.hljs-comment{color:#6C7986;font-style:italic}.hljs-tag{color:#7E8086}.hljs-operator,.hljs-punctuation,.hljs-subst{color:#E7E8EB}.hljs-bullet,.hljs-deletion,.hljs-name,.hljs-selector-tag,.hljs-template-variable,.hljs-variable{color:#EF82B1}.hljs-attr,.hljs-literal,.hljs-number,.hljs-symbol,.hljs-variable.constant_{color:#A4A0F1}.hljs-link{color:#74B6F6}.hljs-class .hljs-title,.hljs-title,.hljs-title.class_{color:#ADD681}.hljs-strong{font-weight:bold;color:#ADD681}.hljs-addition,.hljs-code,.hljs-string,.hljs-title.class_.inherited__{color:#FC6A5D}.hljs-built_in,.hljs-doctag,.hljs-keyword.hljs-atrule,.hljs-quote,.hljs-regexp{color:#74B6F6}.hljs-attribute,.hljs-function .hljs-title,.hljs-section,.hljs-title.function_,.ruby .hljs-property{color:#99E8D5}.diff .hljs-meta,.hljs-template-tag,.hljs-type{color:#99E8D5}.hljs-keyword{color:#EF82B1}.hljs-emphasis{color:#EF82B1;font-style:italic}.hljs-meta,.hljs-meta .hljs-keyword,.hljs-meta .hljs-string{color:#D38D5E}.hljs-meta .hljs-keyword,.hljs-meta-keyword{font-weight:bold}"))
        #else
        VStack {
            Text(configuration.code)
                .font(.caption)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(.secondary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        #endif
    }

    #if !os(watchOS)
    func language(configuration: Configuration) -> Language? {
        guard let rawValue = configuration.language else {
            return .plaintext
        }
        return Language(rawValue: rawValue)
    }
    #endif
}

extension CodeBlockStyle where Self == DefaultCodeBlockStyle {
    public static var `default`: DefaultCodeBlockStyle {
        DefaultCodeBlockStyle()
    }
}

// MARK: Environment

extension View {
    public func markdownCodeBlockStyle<S>(_ style: S) -> some View where S: CodeBlockStyle {
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
