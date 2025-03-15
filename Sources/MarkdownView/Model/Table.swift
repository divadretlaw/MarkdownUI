//
//  Table.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import Foundation
import SwiftUI
import Markdown

struct Table {
    let head: [Cell]
    let body: [Row]
    
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
}

extension Table {
    struct Cell: Identifiable {
        let wrappedValue: Markdown.Table.Cell
        let alignment: HorizontalAlignment
        
        init(_ wrappedValue: Markdown.Table.Cell, alignment: HorizontalAlignment?) {
            self.wrappedValue = wrappedValue
            self.alignment = alignment ?? .center
        }
        
        var id: String {
            wrappedValue.plainText
        }
    }
    
    struct Row: Identifiable {
        let cells: [Cell]
        
        init(_ cells: [Cell]) {
            self.cells = cells
        }
        
        var id: String {
            cells.map(\.id).joined()
        }
    }
}
