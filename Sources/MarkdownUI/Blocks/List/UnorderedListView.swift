//
//  UnorderedListView.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct UnorderedListView: View {
    let markup: UnorderedList
    
    init(_ markup: UnorderedList) {
        self.markup = markup
    }
    
    var body: some View {
        ListItemContainerView(markup)
    }
}

// MARK: - Style

/// A type that applies a custom style to all unordered lists within a ``MarkdownView``.
@MainActor public protocol UnorderedListIndicatorStyle: Sendable {
    /// A view that represents the body of a unordered list.
    associatedtype Body: View

    /// Creates a view that represents the body of a unordered list.
    ///
    /// The system calls this method for each list instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the unordered list.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
    
    /// The properties of the unordered list.
    typealias Configuration = ListIndicatorConfiguration
}

public struct DefaultUnorderedListIndicatorStyle: UnorderedListIndicatorStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            switch configuration.level {
            case .root:
                Text("•")
                    .monospaced()
            case .indented:
                Text("◦")
                    .monospaced()
            default:
                Text("▪")
                    .monospaced()
            }
            
            if let checked = configuration.checked {
                switch checked {
                case .checked:
                    Image(systemName: "checkmark.circle.fill")
                case .unchecked:
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

public extension UnorderedListIndicatorStyle where Self == DefaultUnorderedListIndicatorStyle {
    static var `default`: DefaultUnorderedListIndicatorStyle {
        DefaultUnorderedListIndicatorStyle()
    }
}

// MARK: Environment

public extension View {
    func markdownListIndicatorStyle<S>(_ style: S) -> some View where S: UnorderedListIndicatorStyle {
        environment(\.unorderedListIndicatorStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var unorderedListIndicatorStyle: any UnorderedListIndicatorStyle = DefaultUnorderedListIndicatorStyle()
}

#Preview {
    MarkdownView {
        """
        * Unordered list can use asterisks
        - Or minuses
        + Or pluses
        
        ---
        
        * [x] Checked
        * [ ] Not checked
        """
    }
    .padding()
}

#Preview {
    MarkdownView {
        """
        * First
        * Test
        * Test
            * Second
                * Third
                    * Fourth
                        * Fith
        """
    }
    .padding()
}

#Preview {
    MarkdownView {
        """
        *   A list item with a blockquote:
        
            > This is a blockquote
            > inside a list item.
        """
    }
    .padding()
}
