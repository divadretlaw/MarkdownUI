//
//  DefaultBlockQuoteStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultBlockQuoteStyle: BlockQuoteStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.content
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

extension BlockQuoteStyle where Self == DefaultBlockQuoteStyle {
    public static var `default`: DefaultBlockQuoteStyle {
        DefaultBlockQuoteStyle()
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
    .markdownBlockQuoteStyle(.default)
    .padding()
}
