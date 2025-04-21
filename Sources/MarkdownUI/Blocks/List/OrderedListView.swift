//
//  OrderedListView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct OrderedListView: View {
    let markup: ListItemContainer

    init(_ markup: OrderedList) {
        self.markup = markup
    }

    var body: some View {
        ListItemContainerView(markup)
    }
}

#Preview {
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
        """
    }
    .padding()
}

#Preview {
    MarkdownView {
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

        ---

        1. [x] Checked
        2. [ ] Not checked
        """
    }
    .padding()
}
