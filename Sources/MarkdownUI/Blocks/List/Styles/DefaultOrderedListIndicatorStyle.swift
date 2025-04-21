//
//  DefaultOrderedListIndicatorStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultOrderedListIndicatorStyle: OrderedListIndicatorStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text("\(configuration.displayIndex).")
                .monospacedDigit()

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

extension OrderedListIndicatorStyle where Self == DefaultOrderedListIndicatorStyle {
    public static var `default`: DefaultOrderedListIndicatorStyle {
        DefaultOrderedListIndicatorStyle()
    }
}

#Preview {
    ScrollView {
        MarkdownView {
            """
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            1. Test
            
            ---
            
            1. [x] Checked
            2. [ ] Not checked
            
            ---
            
            1. First
            1. Test
            1. Test
                1. Second
                    1. Third
                        1. Fourth
                            1. Fith
            
            ---
            
            1. A list item with a blockquote:
            
               > This is a blockquote
               > inside a list item.
            """
        }
        .markdownOrderedListIndicatorStyle(.default)
        .padding()
    }
}
