//
//  Text+Extensions.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Nuke
import OSLog

extension Text {
    init(markdown: String, url: URL? = nil) {
        do {
            let attributedString = try AttributedString(
                markdown: markdown,
                options: .init(
                    allowsExtendedAttributes: true,
                    interpretedSyntax: .inlineOnlyPreservingWhitespace,
                    failurePolicy: .returnPartiallyParsedIfPossible,
                    languageCode: nil
                ),
                baseURL: nil
            )

            if let url {
                var container = AttributeContainer()
                container.link = url
                self = Text(attributedString.mergingAttributes(container, mergePolicy: .keepNew))
            } else {
                self = Text(attributedString)
            }
        } catch {
            Logger.text.error("\(error.localizedDescription)")
            self = Text(verbatim: markdown)
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

extension [Text] {
    func joined() -> Text {
        reduce(into: Text(verbatim: "")) { partialResult, text in
            partialResult = partialResult + text
        }
    }
}
