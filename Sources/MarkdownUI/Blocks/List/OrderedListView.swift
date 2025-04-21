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
        1. One
        2. Two
        3. Three
        """
    }
    .padding()
}
