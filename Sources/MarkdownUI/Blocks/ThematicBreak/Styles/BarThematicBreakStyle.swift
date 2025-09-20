//
//  BarThematicBreakStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct BarThematicBreakStyle: ThematicBreakStyle {
    public func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: .infinity)
            .frame(height: 2.5)
    }
}

extension ThematicBreakStyle where Self == BarThematicBreakStyle {
    public static var bar: BarThematicBreakStyle {
        BarThematicBreakStyle()
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
    .markdownThematicBreakStyle(.bar)
    .padding()
}
