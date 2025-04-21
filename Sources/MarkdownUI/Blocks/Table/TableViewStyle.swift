//
//  TableViewStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

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

// MARK: - API

extension View {
    public func markdownTableStyle<S>(_ style: S) -> some View where S: TableStyle {
        environment(\.tableStyle, style)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var tableStyle: any TableStyle = DefaultTableStyle()
}
