//
//  HeadingStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI
import Markdown

// MARK: - Style

/// The properties of the heading.
public struct HeadingConfiguration {
    private let heading: Heading

    init(_ heading: Heading) {
        self.heading = heading
    }

    @MainActor public var content: some View {
        InlineContainerView(heading)
    }

    public var level: Int {
        heading.level
    }
}

/// A type that applies a custom style to all headings within a ``MarkdownView``.
@MainActor public protocol HeadingStyle: Sendable {
    /// A view that represents the body of a heading.
    associatedtype Body: View

    /// Creates a view that represents the body of a heading.
    ///
    /// The system calls this method for each heading instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the heading.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the heading.
    typealias Configuration = HeadingConfiguration
}

// MARK: - API

extension View {
    public func markdownHeadingStyle<S>(_ style: S) -> some View where S: HeadingStyle {
        environment(\.headingStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var headingStyle: any HeadingStyle = DefaultHeadingStyle()
}
