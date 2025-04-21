//
//  CodeBlockStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI
import Markdown

// MARK: - Style

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

// MARK: - API

extension View {
    /// Sets the style for code blocks within this view.
    ///
    /// - Parameter style: The code block style to use for this view.
    public func markdownCodeBlockStyle<S>(_ style: S) -> some View where S: CodeBlockStyle {
        environment(\.codeBlockStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var codeBlockStyle: any CodeBlockStyle = DefaultCodeBlockStyle()
}
