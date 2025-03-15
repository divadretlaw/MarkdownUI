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

@MainActor public protocol UnorderedListIndicatorStyle: Sendable {
    associatedtype Body: View

    func makeBody(configuration: Configuration) -> Body
    
    typealias Configuration = ListIndicatorConfiguration
}

public struct DefaultUnorderedListIndicatorStyle: UnorderedListIndicatorStyle {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    public func makeBody(configuration: Configuration) -> some View {
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
    MarkdownView(
        """
        * Unordered list can use asterisks
        - Or minuses
        + Or pluses
        
        ---
        
        * [x] Checked
        * [ ] Not checked
        """
    )
    .padding()
}

#Preview {
    MarkdownView(
        """
        * First
        * Test
        * Test
            * Second
                * Third
                    * Fourth
                        * Fith
        """
    )
    .padding()
}

#Preview {
    MarkdownView(
        """
        *   A list item with a blockquote:

            > This is a blockquote
            > inside a list item.
        """
    )
    .padding()
}
