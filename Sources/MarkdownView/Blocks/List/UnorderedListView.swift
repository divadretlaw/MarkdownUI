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

    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = UnorderedListIndicatorConfiguration
}

public struct UnorderedListIndicatorConfiguration {
    internal let listLevel: ListLevel
    
    init(level: ListLevel) {
        self.listLevel = level
    }
    
    public var level: Int {
        listLevel.rawValue
    }
}

public struct DefaultUnorderedListIndicatorStyle: UnorderedListIndicatorStyle {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    
    public func makeBody(configuration: Configuration) -> some View {
        switch configuration.listLevel {
        case .root:
            Text("•")
                .monospaced()
        case .one:
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
    func markdownUnorderedListIndicatorStyle<S>(_ style: S) -> some View where S: UnorderedListIndicatorStyle {
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
