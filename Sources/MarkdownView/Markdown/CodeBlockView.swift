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
        GroupBox {
            Text(markup.code.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.callout)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
