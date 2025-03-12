//
//  CodeBlockView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct CodeBlockView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    let markup: CodeBlock
    
    init(_ markup: CodeBlock) {
        self.markup = markup
    }
    
    var body: some View {
        #if os(watchOS) || os(tvOS)
        VStack {
            Text(markup.code.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.caption)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(.secondary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        #else
        GroupBox {
            Text(markup.code.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.callout)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        #endif
    }
}

#Preview {
    MarkdownView(
        """
        ```javascript
        var s = "JavaScript syntax highlighting";
        alert(s);
        ```
         
        ```python
        s = "Python syntax highlighting"
        print s
        ```
         
        ```
        No language indicated, so no syntax highlighting. 
        But let's throw in a <b>tag</b>.
        ```
        """
    )
    .padding(.horizontal, 10)
}
