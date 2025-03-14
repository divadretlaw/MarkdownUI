//
//  File.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI
import Markdown

struct HeadingView: View {
    @Environment(\.headingStyle) private var style
    
    let configuration: HeadingConfiguration
    
    init(_ markup: Heading) {
        self.configuration = HeadingConfiguration(markup)
    }
    
    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

private struct HeadingFont: ViewModifier {
    @ScaledMetric(relativeTo: .body)
    private var size: CGFloat = 28
    @ScaledMetric(relativeTo: .title)
    private var offset: CGFloat = 2
    
    let level: Int
    
    init(level: Int) {
        self.level = level
    }
    
    func body(content: Content) -> some View {
        content.font(font)
    }
    
    var factor: CGFloat {
        switch level {
        case 1...6:
            CGFloat(level - 1)
        default:
            6
        }
    }
    
    var font: Font {
        .system(
            size: size - offset * factor,
            weight: .semibold,
            design: nil
        )
    }
}

// MARK: - Style

@MainActor public protocol HeadingStyle: Sendable {
    associatedtype Body: View

    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = HeadingConfiguration
}

public struct HeadingConfiguration {
    private let heading: Heading
    
    init(_ heading: Heading) {
        self.heading = heading
    }
    
    @MainActor public var content: some View {
        InlineContainerView(heading)
    }
    
    public var level: Int {
        heading.level
    }
}

public struct DefaultHeadingStyle: HeadingStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .modifier(HeadingFont(level: configuration.level))
            .bold()
            .padding(.vertical, 8)
        
    }
}

public extension HeadingStyle where Self == DefaultHeadingStyle {
    static var `default`: DefaultHeadingStyle {
        DefaultHeadingStyle()
    }
}

public struct DividerHeadingStyle: HeadingStyle {
    let level: Int
    
    init(upTo level: Int) {
        self.level = level
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.content
                .modifier(HeadingFont(level: configuration.level))
                .bold()
                .padding(.vertical, 8)
            if configuration.level <= level {
                Divider()
                    .background(.secondary)
            }
        }
    }
}

public extension HeadingStyle where Self == DividerHeadingStyle {
    static var divider: DividerHeadingStyle {
        DividerHeadingStyle(upTo: 2)
    }
    
    static func divider(upTo level: Int) -> DividerHeadingStyle {
        DividerHeadingStyle(upTo: level)
    }
}

// MARK: Environment

public extension View {
    func markdownHeadingStyle<S>(_ style: S) -> some View where S: HeadingStyle {
        environment(\.headingStyle, style)
    }
}

private extension EnvironmentValues {
    @Entry var headingStyle: any HeadingStyle = DefaultHeadingStyle()
}

// MARK: - Preview

#Preview("Default") {
    MarkdownView(
        """
        # H1
        ## H2
        ### H3
        #### H4
        ##### H5
        ###### H6

        Alternatively, for H1 and H2, an underline-ish style:

        Alt-H1
        ======

        Alt-H2
        ------
        """
    )
    .padding(.horizontal, 10)
    .markdownHeadingStyle(.default)
    .buttonStyle(.automatic)
}

#Preview("Divider") {
    MarkdownView(
        """
        # H1
        ## H2
        ### H3
        #### H4
        ##### H5
        ###### H6

        Alternatively, for H1 and H2, an underline-ish style:

        Alt-H1
        ======

        Alt-H2
        ------
        """
    )
    .padding(.horizontal, 10)
    .markdownHeadingStyle(.divider(upTo: 2))
}
