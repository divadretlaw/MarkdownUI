//
//  InlineCodeAdapter.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Public

extension View {
    /// Sets the inline code appearance within this view
    ///
    /// - Parameter style: The foreground style of the text
    ///
    /// The background style will be the style with 20% opacity inside a rounded rectangle
    public func markdownInlineCodeStyle<S>(
        _ style: S
    ) -> some View where S: ShapeStyle {
        environment(
            \.markdownInlineCode, MarkdownInlineCode(foreground: style)
        )
    }

    /// Sets the inline code appearance within this view
    ///
    /// - Parameters:
    ///   - foreground: The foreground style of the text.
    ///   - background: The background style of the text.
    ///
    /// The styles will inside a rounded rectangle
    public func markdownInlineCodeStyle<S1, S2>(
        _ foreground: S1,
        _ background: S2
    ) -> some View where S1: ShapeStyle, S2: ShapeStyle {
        environment(
            \.markdownInlineCode, MarkdownInlineCode(foreground: foreground, background: background)
        )
    }

    /// Sets the inline code appearance within this view
    ///
    /// - Parameters:
    ///   - foreground: The foreground style of the text.
    ///   - background: The background style of the text.
    ///   - shape: The background shape of the text.
    public func markdownInlineCodeStyle<S1, S2, S3>(
        _ foreground: S1,
        _ background: S2,
        _ shape: S3
    ) -> some View where S1: ShapeStyle, S2: ShapeStyle, S3: Shape {
        environment(
            \.markdownInlineCode, MarkdownInlineCode(foreground: foreground, background: background, shape: shape)
        )
    }
}

// MARK: - Internal

struct MarkdownInlineCode: Sendable {
    let foreground: any ShapeStyle
    let background: any ShapeStyle
    let shape: any Shape

    init<S>(
        foreground: S
    ) where S: ShapeStyle {
        self.foreground = foreground
        self.background = foreground.opacity(0.2)
        self.shape = RoundedRectangle(cornerRadius: 4, style: .continuous)
    }

    init<S1, S2>(
        foreground: S1,
        background: S2
    ) where S1: ShapeStyle, S2: ShapeStyle {
        self.foreground = foreground
        self.background = background
        self.shape = RoundedRectangle(cornerRadius: 4, style: .continuous)
    }

    init<S1, S2, S3>(
        foreground: S1,
        background: S2,
        shape: S3
    ) where S1: ShapeStyle, S2: ShapeStyle, S3: Shape {
        self.foreground = foreground
        self.background = background
        self.shape = shape
    }
}

extension EnvironmentValues {
    @Entry var markdownInlineCode: MarkdownInlineCode = MarkdownInlineCode(
        foreground: .primary,
        background: .fill.opacity(0.8)
    )
}
