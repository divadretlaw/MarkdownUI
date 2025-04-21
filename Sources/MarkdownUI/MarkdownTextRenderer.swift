//
//  MarkdownTextRenderer.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import SwiftUI

struct MarkdownTextRenderer: TextRenderer {
    let inlineCode: MarkdownInlineCode

    init(inlineCode: MarkdownInlineCode) {
        self.inlineCode = inlineCode
    }

    // MARK: - TextRenderer

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            var inlineRuns: [Text.Layout.Line.Element] = []
            defer {
                drawInlineRuns(&inlineRuns, in: context)
            }

            for run in line {
                if run[InlineCodeAttribute.self] != nil {
                    inlineRuns.append(run)
                } else {
                    drawInlineRuns(&inlineRuns, in: context)
                    context.draw(run)
                }
            }
        }
    }

    private func drawInlineRuns(_ runs: inout [Text.Layout.Line.Element], in context: GraphicsContext) {
        defer {
            runs = []
        }

        guard
            !runs.isEmpty,
            let rect = runs.map(\.typographicBounds.rect).joinedWidth()
        else {
            return
        }

        let shape = inlineCode.shape
            .path(in: rect)

        context.fill(shape, with: .style(inlineCode.background))

        for run in runs {
            context.draw(run)
        }
    }
}

struct InlineCodeAttribute: TextAttribute {
}

#Preview(traits: .sizeThatFitsLayout) {
    MarkdownView {
        """
        Regular text
        
        Inline `Hello World`.
        
        `prefix` `postfix`
        """
    }
    .markdownInlineCodeStyle(.tint)
    .padding()
}
