//
//  UnorderedListView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct UnorderedListView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    @Environment(\.markdownListLevel) private var listLevel
    
    let markup: UnorderedList
    
    init(_ markup: UnorderedList) {
        self.markup = markup
    }
    
    var body: some View {
        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 8, verticalSpacing: lineSpacing) {
            ForEach(0..<markup.childCount, id: \.self) { (index: Int) in
                if let listItem = markup.child(at: index) {
                    GridRow {
                        Group {
                            Text(bullet)
                            if let listItem = listItem as? ListItem, let checked = listItem.checkbox {
                                switch checked {
                                case .checked:
                                    Image(systemName: "checkmark.circle.fill")
                                case .unchecked:
                                    Image(systemName: "circle")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .gridColumnAlignment(.trailing)
                        .monospaced()
                        
                        Group {
                            if let markup = listItem as? InlineContainer {
                                InlineContainerView(markup)
                            } else {
                                VStack(alignment: .leading, spacing: lineSpacing) {
                                    MarkupView(listItem)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.vertical, listLevel.isRoot ? 10 : 0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .environment(\.markdownListLevel, listLevel.next())
    }
    
    var bullet: String {
        switch listLevel {
        case .root:
            "•"
        case .one:
            "◦"
        default:
            "▪"
        }
    }
}

#Preview {
    MarkdownView(
        """
        * Unordered list can use asterisks
        - Or minuses
        + Or pluses
        
        ---
        
        * [x] Checked
        * [ ] Not checked
        """
    )
    .padding()
}

#Preview {
    MarkdownView(
        """
        * First
        * Test
        * Test
            * Second
                * Third
                    * Fourth
                        * Fith
        """
    )
    .padding()
}

#Preview {
    MarkdownView(
        """
        *   A list item with a blockquote:

            > This is a blockquote
            > inside a list item.
        """
    )
    .padding()
}
