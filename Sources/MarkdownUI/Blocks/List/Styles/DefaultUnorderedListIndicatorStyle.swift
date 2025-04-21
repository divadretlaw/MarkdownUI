//
//  DefaultUnorderedListIndicatorStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultUnorderedListIndicatorStyle: UnorderedListIndicatorStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            switch configuration.level {
            case .root:
                Text("•")
                    .monospaced()
            case .indented:
                Text("◦")
                    .monospaced()
            default:
                Text("▪")
                    .monospaced()
            }

            if let checked = configuration.checked {
                switch checked {
                case .checked:
                    Image(systemName: "checkmark.circle.fill")
                case .unchecked:
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

extension UnorderedListIndicatorStyle where Self == DefaultUnorderedListIndicatorStyle {
    public static var `default`: DefaultUnorderedListIndicatorStyle {
        DefaultUnorderedListIndicatorStyle()
    }
}

#Preview {
    ScrollView {
        MarkdownView {
            """
            * Unordered list can use asterisks
            - Or minuses
            + Or pluses
            
            ---
            
            * [x] Checked
            * [ ] Not checked
            
            ---
            
            * First
            * Test
            * Test
                * Second
                    * Third
                        * Fourth
                            * Fith
            
            ---
            
            * A list item with a blockquote:
            
              > This is a blockquote
              > inside a list item.
            """
        }
        .markdownUnorderedListIndicatorStyle(.default)
        .padding()
    }
}
