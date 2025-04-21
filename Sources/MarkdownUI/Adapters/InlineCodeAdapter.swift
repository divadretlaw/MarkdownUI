//
//  InlineCodeAdapter.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Public

extension View {
    public func markdownInlineCodeStyle<S>(
        _ style: S
    ) -> some View where S: ShapeStyle {
        environment(
            \.markdownInlineCode, MarkdownInlineCode(foreground: style)
        )
    }

    public func markdownInlineCodeStyle<S1, S2>(
        _ foreground: S1,
        _ background: S2
    ) -> some View where S1: ShapeStyle, S2: ShapeStyle {
        environment(
            \.markdownInlineCode, MarkdownInlineCode(foreground: foreground, background: background)
        )
    }

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
        self.shape = RoundedRectangle(cornerRadius: 5, style: .continuous)
    }

    init<S1, S2>(
        foreground: S1,
        background: S2
    ) where S1: ShapeStyle, S2: ShapeStyle {
        self.foreground = foreground
        self.background = background
        self.shape = RoundedRectangle(cornerRadius: 5, style: .continuous)
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

