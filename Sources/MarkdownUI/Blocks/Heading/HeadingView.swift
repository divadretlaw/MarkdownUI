//
//  HeadingView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct HeadingView: View {
    @Environment(\.headingStyle) private var style

    let configuration: HeadingConfiguration

    init(_ markup: Heading) {
        self.configuration = HeadingConfiguration(markup)
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
            .markdownFont(.heading(configuration.level))
    }
}

// MARK: - Preview

#Preview {
    MarkdownView {
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
    }
    .padding()
}
