//
//  CodeBlockView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown
#if !os(watchOS)
import HighlightJS
import HighlightUI
#endif

struct CodeBlockView: View {
    @Environment(\.markdownFonts) private var fonts
    @Environment(\.codeBlockStyle) private var style

    let configuration: CodeBlockConfiguration

    init(_ markup: CodeBlock) {
        self.configuration = CodeBlockConfiguration(markup)
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
            .markdownFont(.code)
    }
}

// MARK: - Style

// MARK: - Preview

#Preview {
    MarkdownView {
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
    }
    .padding()
}
