//
//  MarkdownTextRenderer.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import SwiftUI

struct MarkdownTextRenderer: TextRenderer {
    let inlineCode: MarkdownInlineCode?

    init(inlineCode: MarkdownInlineCode?) {
        self.inlineCode = inlineCode
    }

    // MARK: - TextRenderer

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            for run in line {
                if run[InlineCodeAttribute.self] != nil, let inlineCode {
                    let copy = context

                    let rect = run.typographicBounds.rect.insetBy(dx: -2, dy: 0)

                    let shape = inlineCode.shape
                        .path(in: rect)

                    copy.fill(shape, with: .style(inlineCode.background))
                    copy.draw(run)
                } else {
                    context.draw(run)
                }
            }
        }
    }
}

struct InlineCodeAttribute: TextAttribute {
}
