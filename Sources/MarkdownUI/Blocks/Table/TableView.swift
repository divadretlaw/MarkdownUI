//
//  TableView.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct TableView: View {
    @Environment(\.tableStyle) private var style

    let configuration: TableConfiguration

    init(_ markup: Markdown.Table) {
        self.configuration = TableConfiguration(from: markup)
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        Colons can be used to align columns.

        | Tables        | Are           | Cool  |
        |:------------- |:-------------:| -----:|
        | col 1 is      | left-aligned  |  $800 |
        | col 3 is      | right-aligned | $1600 |
        | col 2 is      | centered      |   $12 |
        | zebra stripes | are neat      |    $1 |

        There must be at least 3 dashes separating each header cell.
        The outer pipes (|) are optional, and you don't need to make the
        raw Markdown line up prettily. You can also use inline Markdown.

        Markdown | Less | Pretty
        --- | --- | ---
        *Still* | `renders` | **nicely**
        1 | 2 | 3
        """
    }
    .padding()
}
