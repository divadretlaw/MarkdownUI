//
//  Text+Extensions.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

extension Text {
    init(markdown text: String) {
        do {
            let attributedString = try AttributedString(
                markdown: text,
                options: .init(
                    allowsExtendedAttributes: true,
                    interpretedSyntax: .inlineOnlyPreservingWhitespace,
                    failurePolicy: .returnPartiallyParsedIfPossible,
                    languageCode: nil
                ),
                baseURL: nil
            )
            self = Text(attributedString)
        } catch {
            self = Text(verbatim: text)
        }
    }
}

extension Color {
    /// Return a random color
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
