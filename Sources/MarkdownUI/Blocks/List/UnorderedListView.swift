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
        * One
        * Two
        * Three
        """
    }
    .padding()
}
