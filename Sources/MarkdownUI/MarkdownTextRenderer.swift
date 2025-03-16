//
//  MarkdownTextRenderer.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import SwiftUI

struct MarkdownTextRenderer: TextRenderer {
    init() {
    }

    // MARK: - TextRenderer

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            for run in line {
                if run[InlineCodeAttribute.self] != nil {
                    let copy = context

                    let rect = run.typographicBounds.rect.insetBy(dx: -2, dy: 0)

                    let shape = RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .path(in: rect)

                    copy.fill(shape, with: .style(.fill.opacity(0.8)))
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
