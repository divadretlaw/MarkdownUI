//
//  TableConfiguration+Cell.swift
//  MarkdownUI
//
//  Created by David Walter on 16.03.25.
//

import Foundation
import Markdown
import SwiftUI

extension TableConfiguration {
    /// A cell in a table
    public struct Cell: Identifiable {
        public let id = UUID()
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
    }
}
