//
//  TableView.swift
//  MarkdownView
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

// MARK: - Style

/// A type that applies a custom style to all tables within a ``MarkdownView``.
@MainActor public protocol TableStyle: Sendable {
    /// A view that represents the body of a table.
    associatedtype Body: View

    /// Creates a view that represents the body of a table.
    ///
    /// The system calls this method for each table instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the table.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
    
    /// The properties of a table.
    typealias Configuration = TableConfiguration
}

/// The properties of a table.
public struct TableConfiguration {
    /// The cells of the table header
    public let head: [Cell]
    /// A cell in a table
    public struct Cell: Identifiable {
        private let wrappedValue: Markdown.Table.Cell
        /// The preferred horizontal alignment of the cell
        public let alignment: HorizontalAlignment
        
        init(_ wrappedValue: Markdown.Table.Cell, alignment: HorizontalAlignment?) {
            self.wrappedValue = wrappedValue
            self.alignment = alignment ?? .center
        }
        
        /// The content the cell is displaying
        @MainActor var content: some View {
            InlineContainerView(wrappedValue)
        }
        
        public var id: String {
            wrappedValue.plainText
        }
    }
    
    /// The rows of the table
    public let body: [Row]
    /// A row in a table
    public struct Row: Identifiable {
        /// The cells of the row
        public let cells: [Cell]
        
        init(_ cells: [Cell]) {
            self.cells = cells
        }
        
        public var id: String {
            cells.map(\.id).joined()
        }
    }
    
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
                        .gridColumnAlignment(cell.alignment)
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
                            .gridColumnAlignment(cell.alignment)
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

public extension TableStyle where Self == DefaultTableStyle {
    static var `default`: DefaultTableStyle {
        DefaultTableStyle()
    }
}

// MARK: Environment

public extension View {
    func markdownTableStyle<S>(_ style: S) -> some View where S: TableStyle {
        environment(\.tableStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var tableStyle: any TableStyle = DefaultTableStyle()
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
