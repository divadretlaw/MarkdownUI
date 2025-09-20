//
//  TextRenderer+Extensions.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

@MainActor extension Text {
    @ViewBuilder func withRenderer<T>(_ renderer: T) -> some View where T: TextRenderer {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            textRenderer(renderer)
        } else {
            modifier(TextRendererDrawer(renderer: renderer))
        }
    }
}

private struct TextRendererDrawer: ViewModifier {
    let renderer: any TextRenderer

    @State private var anchors: [Text.LayoutKey.AnchoredLayout] = []

    func body(content: Content) -> some View {
        content
            .hidden()
            .onPreferenceChange(Text.LayoutKey.self) { value in
                self.anchors = value
            }
            .overlay {
                Canvas { ctx, size in
                    for anchor in anchors {
                        renderer.draw(layout: anchor.layout, in: &ctx)
                    }
                }
            }
    }
}

#Preview {
    MarkdownView {
        """
        Regular text
        
        Inline `code`.
        """
    }
    .markdownInlineCodeStyle(.tint)
    .padding()
}
