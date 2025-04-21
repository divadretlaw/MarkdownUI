//
//  DefaultThematicBreakStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultThematicBreakStyle: ThematicBreakStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration _: Configuration) -> some View {
        Divider()
    }
}

extension ThematicBreakStyle where Self == DefaultThematicBreakStyle {
    public static var `default`: DefaultThematicBreakStyle {
        DefaultThematicBreakStyle()
    }
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        Hello
        
        ---
        
        World
        """
    }
    .markdownThematicBreakStyle(.default)
    .padding()
}
