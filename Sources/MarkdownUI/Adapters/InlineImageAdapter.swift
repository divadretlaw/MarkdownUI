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

    public func markdownImageScale(
        _ scales: MarkdownImageScale...
    ) -> some View {
        environment(\.markdownImageScale, scales.joined() ?? .default)
    }
}

/// Render mode for Markdown inline images
public enum MarkdownImageMode: Sendable {
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

/// Scale mode for Markdown inline images
public struct MarkdownImageScale: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Scale the image based on the display scale
    public static let display = MarkdownImageScale(rawValue: 1 << 0)
    /// Scale the image to fit the ``MarkdownView`` width
    public static let scaledToFit = MarkdownImageScale(rawValue: 1 << 1)
    /// The default image scale options
    public static let `default`: MarkdownImageScale = [.display, .scaledToFit]
}

// MARK: - Inline

extension EnvironmentValues {
    @Entry var markdownImageMode = MarkdownImageMode.default
    @Entry var markdownImageScale = MarkdownImageScale.default
}
