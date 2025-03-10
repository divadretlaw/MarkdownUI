//
//  BlockQuoteView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct BlockQuoteView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    let markup: BlockQuote
    
    init(_ markup: BlockQuote) {
        self.markup = markup
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            MarkupView(markup)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
        .padding(.leading, 15)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(.secondary)
                .frame(width: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MarkdownView(
    """
    > Blockquotes are very handy in email to emulate reply text.
    > This line is part of the same quote.

    Quote break.

    > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 
    """
    )
    .padding()
}
