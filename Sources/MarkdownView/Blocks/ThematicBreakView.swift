//
//  ThematicBreakView.swift
//  MarkdownView
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

@MainActor public protocol ThematicBreakStyle: Sendable {
    associatedtype Body: View
    
    func makeBody(configuration: Configuration) -> Body
    
    typealias Configuration = ThematicBreakConfiguration
}

public struct ThematicBreakConfiguration {}

public struct DefaultThematicBreakStyle: ThematicBreakStyle {
    public func makeBody(configuration _: Configuration) -> some View {
        Divider()
    }
}

public extension ThematicBreakStyle where Self == DefaultThematicBreakStyle {
    static var `default`: DefaultThematicBreakStyle {
        DefaultThematicBreakStyle()
    }
}

// MARK: Environment

public extension View {
    func markdownThematicBreakStyle<S>(_ style: S) -> some View where S: ThematicBreakStyle {
        environment(\.thematicBreakStyle, style)
    }
}

private extension EnvironmentValues {
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
