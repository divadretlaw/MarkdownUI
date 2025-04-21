//
//  DefaultCodeBlockStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI
import HighlightJS
import HighlightUI

public struct DefaultCodeBlockStyle: CodeBlockStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    static let codeStyle = Style(
        ".hljs{color:#E7E8EB;background:#292A2F}.hljs ::selection,.hljs::selection{background-color:#363945}.hljs-formula,.hljs-params,.hljs-property{}.hljs-comment{color:#6C7986;font-style:italic}.hljs-tag{color:#7E8086}.hljs-operator,.hljs-punctuation,.hljs-subst{color:#E7E8EB}.hljs-bullet,.hljs-deletion,.hljs-name,.hljs-selector-tag,.hljs-template-variable,.hljs-variable{color:#EF82B1}.hljs-attr,.hljs-literal,.hljs-number,.hljs-symbol,.hljs-variable.constant_{color:#A4A0F1}.hljs-link{color:#74B6F6}.hljs-class .hljs-title,.hljs-title,.hljs-title.class_{color:#ADD681}.hljs-strong{font-weight:bold;color:#ADD681}.hljs-addition,.hljs-code,.hljs-string,.hljs-title.class_.inherited__{color:#FC6A5D}.hljs-built_in,.hljs-doctag,.hljs-keyword.hljs-atrule,.hljs-quote,.hljs-regexp{color:#74B6F6}.hljs-attribute,.hljs-function .hljs-title,.hljs-section,.hljs-title.function_,.ruby .hljs-property{color:#99E8D5}.diff .hljs-meta,.hljs-template-tag,.hljs-type{color:#99E8D5}.hljs-keyword{color:#EF82B1}.hljs-emphasis{color:#EF82B1;font-style:italic}.hljs-meta,.hljs-meta .hljs-keyword,.hljs-meta .hljs-string{color:#D38D5E}.hljs-meta .hljs-keyword,.hljs-meta-keyword{font-weight:bold}"
    )

    public func makeBody(configuration: Configuration) -> some View {
        #if !os(watchOS)
        CodeBox(configuration.code, language: language(configuration: configuration))
            .codeStyle(DefaultCodeBlockStyle.codeStyle)
        #else
        VStack {
            Text(configuration.code)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(.secondary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        #endif
    }

    #if !os(watchOS)
    func language(configuration: Configuration) -> Language? {
        guard let rawValue = configuration.language else {
            return .plaintext
        }
        return Language(rawValue: rawValue)
    }
    #endif
}

extension CodeBlockStyle where Self == DefaultCodeBlockStyle {
    public static var `default`: DefaultCodeBlockStyle {
        DefaultCodeBlockStyle()
    }
}

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
    .markdownCodeBlockStyle(.default)
    .padding()
}
