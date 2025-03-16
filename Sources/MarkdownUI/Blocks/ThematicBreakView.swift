//
//  ThematicBreakView.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import Markdown
import SwiftUI

struct ThematicBreakView: View {
    @Environment(\.thematicBreakStyle) private var style

    let configuration: ThematicBreakConfiguration

    init() {
        self.configuration = ThematicBreakConfiguration()
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Style

/// A type that applies a custom style to all thematic breaks within a ``MarkdownView``.
@MainActor public protocol ThematicBreakStyle: Sendable {
    /// A view that represents the body of a thematic break.
    associatedtype Body: View

    /// Creates a view that represents the body of a thematic break.
    ///
    /// The system calls this method for each thematic break instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the thematic break.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the thematic break.
    typealias Configuration = ThematicBreakConfiguration
}

/// The properties of the thematic break.
public struct ThematicBreakConfiguration {}

public struct DefaultThematicBreakStyle: ThematicBreakStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration _: Configuration) -> some View {
        Divider()
    }
}

extension ThematicBreakStyle where Self == DefaultThematicBreakStyle {
    public static var `default`: DefaultThematicBreakStyle {
        DefaultThematicBreakStyle()
    }
}

// MARK: Environment

extension View {
    public func markdownThematicBreakStyle<S>(_ style: S) -> some View where S: ThematicBreakStyle {
        environment(\.thematicBreakStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var thematicBreakStyle: any ThematicBreakStyle = DefaultThematicBreakStyle()
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        Hello

        ---

        World
        """
    }
    .padding()
}
