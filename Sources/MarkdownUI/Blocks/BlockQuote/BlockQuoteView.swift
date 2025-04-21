//
//  BlockQuoteView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct BlockQuoteView: View {
    @Environment(\.blockQuoteStyle) private var style

    let configuration: BlockQuoteConfiguration

    init(_ markup: BlockQuote) {
        self.configuration = BlockQuoteConfiguration(markup)
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        > Blockquotes are very handy in email to emulate reply text.
        > This line is part of the same quote.

        Quote break.

        > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote.

        > This quote has a quote inside
        >> I'm a quote
        >>
        >> I'm a quote
        """
    }
    .padding()
}
