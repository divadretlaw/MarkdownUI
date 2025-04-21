//
//  UnorderedListView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct UnorderedListView: View {
    let markup: UnorderedList

    init(_ markup: UnorderedList) {
        self.markup = markup
    }

    var body: some View {
        ListItemContainerView(markup)
    }
}

#Preview {
    MarkdownView {
        """
        * Unordered list can use asterisks
        - Or minuses
        + Or pluses

        ---

        * [x] Checked
        * [ ] Not checked
        """
    }
    .padding()
}

#Preview {
    MarkdownView {
        """
        * First
        * Test
        * Test
            * Second
                * Third
                    * Fourth
                        * Fith
        """
    }
    .padding()
}

#Preview {
    MarkdownView {
        """
        *   A list item with a blockquote:

            > This is a blockquote
            > inside a list item.
        """
    }
    .padding()
}
