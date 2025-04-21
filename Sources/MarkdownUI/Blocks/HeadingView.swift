//
//  HeadingView.swift
//  MarkdownUI
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
            .markdownFont(.heading(configuration.level))
    }
}

// MARK: - Style

/// A type that applies a custom style to all headings within a ``MarkdownView``.
@MainActor public protocol HeadingStyle: Sendable {
    /// A view that represents the body of a heading.
    associatedtype Body: View

    /// Creates a view that represents the body of a heading.
    ///
    /// The system calls this method for each heading instance in a ``MarkdownView``.
    ///
    /// - Parameter configuration: The properties of the heading.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body

    /// The properties of the heading.
    typealias Configuration = HeadingConfiguration
}

/// The properties of the heading.
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
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(.vertical, 8)

    }
}

extension HeadingStyle where Self == DefaultHeadingStyle {
    public static var `default`: DefaultHeadingStyle {
        DefaultHeadingStyle()
    }
}

public struct DividerHeadingStyle: HeadingStyle {
    let level: Int

    nonisolated init(upTo level: Int) {
        self.level = level
    }

    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.content
                .padding(.vertical, 8)
            if configuration.level <= level {
                Divider()
                    .background(.secondary)
            }
        }
    }
}

extension HeadingStyle where Self == DividerHeadingStyle {
    public static var divider: DividerHeadingStyle {
        DividerHeadingStyle(upTo: 2)
    }

    public static func divider(upTo level: Int) -> DividerHeadingStyle {
        DividerHeadingStyle(upTo: level)
    }
}

// MARK: Environment

extension View {
    public func markdownHeadingStyle<S>(_ style: S) -> some View where S: HeadingStyle {
        environment(\.headingStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var headingStyle: any HeadingStyle = DefaultHeadingStyle()
}

// MARK: - Preview

#Preview("Default") {
    MarkdownView {
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
    }
    .padding()
    .markdownHeadingStyle(.default)
}

#Preview("Divider") {
    MarkdownView {
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
    }
    .padding()
    .markdownHeadingStyle(.divider(upTo: 2))
}
