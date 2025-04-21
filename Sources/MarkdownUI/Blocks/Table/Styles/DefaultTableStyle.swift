//
//  DefaultTableStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultTableStyle: TableStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 0) {
            GridRow {
                EnumeratedForEach(configuration.head) { index, cell in
                    cell.content
                        .padding(.vertical, 2)
                        .bold()
                        .gridColumnAlignment(cell.horizontalAlignment ?? .leading)
                    if index < (configuration.head.count - 1) {
                        Rectangle()
                            .fill(.secondary)
                            .frame(maxWidth: 0.5)
                    }
                }
            }
            .padding(.horizontal, 2)

            Rectangle()
                .fill(.secondary)
                .frame(height: 1)

            ForEach(configuration.body) { row in
                GridRow {
                    EnumeratedForEach(row.cells) { index, cell in
                        cell.content
                            .padding(.vertical, 1)
                            .gridColumnAlignment(cell.horizontalAlignment ?? .leading)
                        if index < (row.cells.count - 1) {
                            Rectangle()
                                .fill(.secondary)
                                .frame(maxWidth: 0.5)
                        }
                    }
                }
                .padding(.horizontal, 2)

                Rectangle()
                    .fill(.secondary)
                    .frame(maxHeight: 0.5)

            }
        }
        .overlay {
            Rectangle()
                .stroke(Color.secondary, lineWidth: 1)
        }
        .padding(.vertical, 5)
    }
}

extension TableStyle where Self == DefaultTableStyle {
    public static var `default`: DefaultTableStyle {
        DefaultTableStyle()
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
    .markdownTableStyle(.default)
    .padding()
}
