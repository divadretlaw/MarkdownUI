//
//  TableConfiguration+Row.swift
//  MarkdownUI
//
//  Created by David Walter on 16.03.25.
//

import Foundation

extension TableConfiguration {
    /// A row in a table
    public struct Row: Identifiable {
        public let id = UUID()
        /// The cells of the row
        public let cells: [Cell]
        
        init(_ cells: [Cell]) {
            self.cells = cells
        }
    }
}
