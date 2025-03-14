//
//  MarkupView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct MarkupView: View {
    let markup: Markup
    
    init(_ markup: Markup) {
        self.markup = markup
    }
    
    var body: some View {
        MarkupIterator(markup) { child in
            switch child {
            case let value as Markdown.Heading:
                HeadingView(value)
            case let value as Markdown.Text:
                SwiftUI.Text(verbatim: value.plainText)
            case let value as Markdown.Strong:
                InlineContainerView(value).bold()
            case let value as Markdown.Emphasis:
                InlineContainerView(value).italic()
            case let value as Markdown.Strikethrough:
                InlineContainerView(value).strikethrough()
            case let value as Markdown.InlineCode:
                SwiftUI.Text(value.code).monospaced()
            case let value as Markdown.SoftBreak:
                SwiftUI.Text(verbatim: value.plainText)
            case let value as Markdown.LineBreak:
                SwiftUI.Text(verbatim: value.plainText)
            case let value as Markdown.CodeBlock:
                CodeBlockView(value)
            case let value as Markdown.BlockQuote:
                BlockQuoteView(value)
            case let value as Markdown.Image:
                InlineContainerView(value)
            case let value as Markdown.OrderedList:
                OrderedListView(value)
            case let value as Markdown.UnorderedList:
                UnorderedListView(value)
            case let value as Markdown.Table:
                TableView(value)
            case is Markdown.ThematicBreak:
                Divider()
            case let value as Markdown.Paragraph:
                InlineContainerView(value)
            default:
                SwiftUI.Text(markdown: child.format())
            }
        }
    }
}

#Preview {
    ScrollView {
        MarkdownView(
        """
        Opening paragraph, with an ordered list of autumn leaves I found
        
        1. A big leaf
        1. Some small leaves:
            1. Red (nested)
            2. **Orange**
            3. Yellow
        1. A medium sized leaf that ~~maybe~~ was pancake shaped
        
        Unordered list of fruits:
        
        - Blueberries
        - Apples
            - Macintosh
            - Honey crisp
            - Cortland
        - Banana
        
        ### Fancy Header Title
        
        Here's what someone said:
        
        > I think blockquotes are cool
        
        Nesting **an *[emphasized link](https://apolloapp.io)* inside strong text**, neato!
        
        And then they mentiond code around `NSAttributedString` that looked like this code block:
        
        ```swift
        func yeah() -> String {
            // TODO: Write code
        }
        ```
        
        Tables are even supported but (but need more than `NSAttributedString` for support :p)
        """
        )
        .padding(.horizontal, 10)
    }
}
