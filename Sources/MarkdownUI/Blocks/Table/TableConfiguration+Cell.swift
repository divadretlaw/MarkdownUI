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
        /// The preferred column alignment of the cell
        public let columnAlignment: Markdown.Table.ColumnAlignment?
        
        init(_ wrappedValue: Markdown.Table.Cell, alignment: Markdown.Table.ColumnAlignment?) {
            self.wrappedValue = wrappedValue
            self.columnAlignment = alignment ?? .center
        }
        
        // MARK: - SwiftUI
        
        /// The content the cell is displaying
        @MainActor public var content: some View {
            InlineContainerView(wrappedValue)
        }
        
        /// The preferred horizontal alignment of the cell
        public var horizontalAlignment: HorizontalAlignment? {
            switch columnAlignment {
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
        
        /// The preferred alignment of the cell
        public var alignment: Alignment? {
            switch columnAlignment {
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
    }
}
