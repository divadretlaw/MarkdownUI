//
//  HeadingFonts.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

// MARK: - Public

public enum MarkdownFontType: Hashable, Equatable, Sendable {
    case heading(_ level: Int)
    case body
    case code
}

extension View {
    /// Overrides the font for markdown in this view.
    ///
    /// - Parameters:
    ///   - font: The font to use in this view.
    ///   - types: The types the font should apply to.
    /// - Returns: A view with the font set to the value you supply for the given type.
    public func markdownFont(_ font: Font?, for types: MarkdownFontType...) -> some View {
        transformEnvironment(\.markdownFonts) { fonts in
            for type in types {
                fonts[type] = font
            }
        }
    }
}

// MARK: - Internal

extension EnvironmentValues {
    @Entry var markdownFonts: [MarkdownFontType: Font] = [.body: .body, .code: .callout]
}

extension View {
    func markdownFont(_ type: MarkdownFontType) -> some View {
        modifier(FontApplier(type: type))
    }
}

private struct FontApplier: ViewModifier {
    @Environment(\.markdownFonts) private var fonts

    @ScaledMetric(relativeTo: .body)
    private var size: CGFloat = 28
    @ScaledMetric(relativeTo: .title)
    private var offset: CGFloat = 2

    let type: MarkdownFontType

    init(type: MarkdownFontType) {
        self.type = type
    }

    func body(content: Content) -> some View {
        content.font(font)
    }

    var font: Font {
        if let font = fonts[type] {
            return font
        } else {
            switch type {
            case .heading(let level):
                return Font.system(
                    size: size - offset * CGFloat(level - 1),
                    weight: .semibold,
                    design: nil
                )
            case .body:
                return .body
            case .code:
                return .callout
            }
        }
    }
}
