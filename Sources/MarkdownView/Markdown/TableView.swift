//
//  TableView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct TableView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    let table: Table
    
    init(markup: Markdown.Table) {
        self.init(table: Table(from: markup))
    }
    
    init(table: Table) {
        self.table = table
    }
    
    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 2) {
            GridRow {
                ForEach(table.head) { cell in
                    InlineContainerView(cell.wrappedValue)
                        .bold()
                        .gridColumnAlignment(cell.alignment)
                }
            }
            .padding(.horizontal, 2)
            
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 0.5)
            
            ForEach(table.body) { row in
                GridRow {
                    ForEach(row.cells) { cell in
                        InlineContainerView(cell.wrappedValue)
                            .gridColumnAlignment(cell.alignment)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .overlay {
            Rectangle()
                .stroke(Color.secondary, lineWidth: 0.5)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    MarkdownView(
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
    )
    .padding(.horizontal, 10)
}
