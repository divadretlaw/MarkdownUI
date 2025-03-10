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
        VStack(alignment: .leading, spacing: lineSpacing) {
            ForEach(0..<markup.childCount, id: \.self) { (index: Int) in
                if let listItem = markup.child(at: index) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Group {
                            listLevel.prefix
                            Text(bullet)
                        }
                        .font(.body.monospaced())
                        
                        if let markup = listItem as? InlineContainer {
                            InlineContainerView(markup)
                        } else {
                            VStack(alignment: .leading, spacing: lineSpacing) {
                                MarkupView(listItem)
                            }
                        }
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
        """
    )
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
}

#Preview {
    MarkdownView(
        """
        *   A list item with a blockquote:

            > This is a blockquote
            > inside a list item.
        """
    )
}
