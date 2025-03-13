//
//  InlineContainerView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown
import Nuke

struct InlineContainerView: View {
    @Environment(\.displayScale) private var scale
    @Environment(ImageManager.self) var imageManager
    
    let markup: InlineContainer
    
    init(_ markup: InlineContainer) {
        self.markup = markup
    }
    
    var body: some View {
        render(children: markup.inlineChildren)
    }
    
    func render(children: LazyMapSequence<MarkupChildren, InlineMarkup>) -> SwiftUI.Text {
        children
            .compactMap { markup in
                switch markup {
                case let value as Markdown.Text:
                    return SwiftUI.Text(verbatim: value.plainText)
                case let value as Markdown.SoftBreak:
                    return SwiftUI.Text(verbatim: value.plainText)
                case let value as Markdown.LineBreak:
                    return SwiftUI.Text(verbatim: value.plainText)
                case let value as Markdown.InlineCode:
                    return SwiftUI.Text(verbatim: value.code).monospaced()
                case let value as Markdown.Strong:
                    return render(children: value.inlineChildren).bold()
                case let value as Markdown.Emphasis:
                    return render(children: value.inlineChildren).italic()
                case let value as Markdown.Strikethrough:
                    return render(children: value.inlineChildren).strikethrough()
                case let value as Markdown.Image:
                    switch imageManager.image(for: value, scale: scale) {
                    case let .success(image):
                        return SwiftUI.Text(image: image)
                    case .failure:
                        return SwiftUI.Text("\(Image(systemName: "photo.badge.exclamationmark"))")
                    }
                case let value as Markdown.Link:
                    if let destination = value.destination, URL(string: destination) != nil {
                        return SwiftUI.Text("[\(render(children: value.inlineChildren).foregroundStyle(.tint))](\(destination))")
                    } else {
                        return SwiftUI.Text(verbatim: value.plainText)
                    }
                default:
                    let markdown = markup.format()
                    guard !markdown.isEmpty else { return nil }
                    return SwiftUI.Text(markdown: markdown)
                }
            }
            .reduce(into: Text(verbatim: "")) { partialResult, text in
                partialResult = partialResult + text
            }
    }
}

#Preview("Emphasis") {
    MarkdownView(
        """
        Emphasis, aka italics, with *asterisks* or _underscores_.

        Strong emphasis, aka bold, with **asterisks** or __underscores__.

        Combined emphasis with **asterisks and _underscores_**.

        Strikethrough uses two tildes. ~~Scratch this.~~
        """
    )
    .padding()
}

#Preview("Links") {
    MarkdownView(
        """
        [I'm an inline-style link](https://www.google.com)

        [I'm an inline-style link with title](https://www.google.com "Google's Homepage")

        [I'm a reference-style link][Arbitrary case-insensitive reference text]

        [I'm a relative reference to a repository file](../blob/master/LICENSE)

        [You can use numbers for reference-style link definitions][1]

        Or leave it empty and use the [link text itself].

        URLs and URLs in angle brackets will automatically get turned into links. 
        http://www.example.com or <http://www.example.com> and sometimes 
        example.com (but not on Github, for example).

        Some text to show that the reference links can follow later.

        [arbitrary case-insensitive reference text]: https://www.mozilla.org
        [1]: http://slashdot.org
        [link text itself]: http://www.reddit.com
        """
    )
    .padding()
}

#Preview("Code and Syntax Highlighting") {
    MarkdownView(
        """
        Inline `code` has `back-ticks around` it.
        """
    )
    .padding(.horizontal, 10)
}

#Preview("Images") {
    MarkdownView(
        """
        ![](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png)
        
        Here's our logo (hover to see the title text):

        Inline-style:
        ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

        Reference-style:
        ![alt text][logo]

        [logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
        """
    )
    .padding(.horizontal, 10)
}
