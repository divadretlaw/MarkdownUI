//
//  OrderedListView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct OrderedListView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    @Environment(\.markdownListLevel) private var listLevel
    
    let markup: OrderedList
    
    init(_ markup: OrderedList) {
        self.markup = markup
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            ForEach(0..<markup.childCount, id: \.self) { (index: Int) in
                let indexDescription = markup.index(offset: index)
                if let listItem = markup.child(at: index) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Group {
                            listLevel.prefix
                            Text(indexDescription)
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
}

private extension OrderedList {
    func index(offset: Int) -> String {
        "\(startIndex + UInt(offset))."
    }
}

#Preview {
    MarkdownView(
        """
        1. First ordered list item
        2. Another item
            * Unordered sub-list. 
        1. Actual numbers don't matter, just that it's a number
            1. Ordered sub-list
        4. And another item.

           You can have properly indented paragraphs within list items. Notice the blank line above, and the leading spaces (at least one, but we'll use three here to also align the raw Markdown).

           To have a line break without a paragraph, you will need to use two trailing spaces.  
           Note that this line is separate, but within the same paragraph.  
           (This is contrary to the typical GFM line break behaviour, where trailing spaces are not required.)
        """
    )
}
