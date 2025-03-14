//
//  Text+Extensions.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Nuke

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
    
    init(image: PlatformImage?) {
        if let image {
            self = Text(image: image)
        } else {
            self = Text("\(Image(systemName: "photo.badge.arrow.down").symbolRenderingMode(.multicolor))")
        }
    }
    
    private init(image: PlatformImage) {
        #if canImport(UIKit)
        self = Text("\(Image(uiImage: image))")
        #elseif canImport(AppKit)
        self = Text("\(Image(nsImage: image))")
        #else
        self = Text("\(Image(systemName: "photo.badge.exclamationmark").symbolRenderingMode(.multicolor))")
        #endif
    }
}
