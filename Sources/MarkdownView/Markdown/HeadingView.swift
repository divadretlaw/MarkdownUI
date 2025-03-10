//
//  File.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct HeadingView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    @ScaledMetric(relativeTo: .title)
    private var size: CGFloat = 28
    @ScaledMetric(relativeTo: .title)
    private var offset: CGFloat = 2
    
    let markup: Heading
    
    init(_ markup: Heading) {
        self.markup = markup
    }
    
    var body: some View {
        InlineContainerView(markup)
            .font(font)
            .bold()
            .padding(.vertical, 8)
    }
    
    var factor: CGFloat {
        switch markup.level {
        case 1...6:
            CGFloat(markup.level - 1)
        default:
            6
        }
    }
    
    var font: Font {
        .system(
            size: size - offset * factor,
            weight: .semibold,
            design: nil
        )
    }
}

#Preview {
    VStack(alignment: .leading) {
        HeadingView(Heading(level: 1, Markdown.Text("Hello 1")))
        HeadingView(Heading(level: 2, Markdown.Text("Hello 2")))
        HeadingView(Heading(level: 3, Markdown.Text("Hello 3")))
        HeadingView(Heading(level: 4, Markdown.Text("Hello 4")))
        HeadingView(Heading(level: 5, Markdown.Text("Hello 5")))
        HeadingView(Heading(level: 6, Markdown.Text("Hello 6")))
    }
}

#Preview {
    MarkdownView(
        """
        # H1
        ## H2
        ### H3
        #### H4
        ##### H5
        ###### H6

        Alternatively, for H1 and H2, an underline-ish style:

        Alt-H1
        ======

        Alt-H2
        ------
        """
    )
    .padding(.horizontal, 10)
    .font(.largeTitle)
}
