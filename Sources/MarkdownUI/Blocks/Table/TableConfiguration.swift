//
//  TableConfiguration.swift
//  MarkdownUI
//
//  Created by David Walter on 16.03.25.
//

import Foundation
import Markdown
import SwiftUI

/// The properties of a table.
public struct TableConfiguration {
    /// The cells of the table header
    public let head: [Cell]
    
    /// The rows of the table
    public let body: [Row]
    
    init(head: [Cell], body: [Row]) {
        self.head = head
        self.body = body
    }
    
    init(from table: Markdown.Table) {
        let columnAlignments: [HorizontalAlignment?] = table.columnAlignments.map { alignment in
            switch alignment {
            case .left:
                return .leading
            case .right:
                return .trailing
            case .center:
                return .center
            default:
                return nil
            }
        }
        
        let head = table.head.children
            .compactMap { $0 as? Markdown.Table.Cell }
            .enumerated()
            .map { index, cell in
                Cell(cell, alignment: columnAlignments[index])
            }
        
        let body = table.body.children
            .compactMap { row in
                let cells = row.children
                    .compactMap { $0 as? Markdown.Table.Cell }
                    .enumerated()
                    .map { index, cell in
                        Cell(cell, alignment: columnAlignments[index])
                    }
                return Row(cells)
            }
        
        self.init(head: head, body: body)
    }
    
    /// Number of columns in the table
    public var count: Int {
        head.count
    }
}
