//
//  InlineImageAdapter.swift
//  MarkdownUI
//
//  Created by David Walter on 04.06.25.
//

import SwiftUI

// MARK: - Public

extension View {
    /// Sets the inline image render within this view
    ///
    /// - Parameter style: The foreground style of the text
    public func markdownImageMode(
        _ style: MarkdownImageMode
    ) -> some View {
        environment(\.markdownImageMode, style)
    }
}

/// Render mode for Markdown inline images
public enum MarkdownImageMode {
    /// Renders all images
    case render
    /// Replaces all images with it's title, if available, or its alt text
    case replaceWithText
    /// Replaces all images with the given image
    case replaceWithImage(Image)

    /// Replaces all images with the given symbol
    public static func replaceWithSymbol(systemName: String) -> MarkdownImageMode {
        MarkdownImageMode.replaceWithImage(Image(systemName: systemName))
    }

    static let `default`: Self = .render
}

// MARK: - Inline

extension EnvironmentValues {
    @Entry var markdownImageMode = MarkdownImageMode.default
}
