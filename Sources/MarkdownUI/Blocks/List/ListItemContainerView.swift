//
//  ListItemContainerView.swift
//  MarkdownUI
//
//  Created by David Walter on 14.03.25.
//

import SwiftUI
import Markdown

struct ListItemContainerView: View {
    @Environment(\.lineSpacing) private var lineSpacing
    @Environment(\.listLevel) private var listLevel
    @Environment(\.orderedListIndicatorStyle) private var orderedStyle
    @Environment(\.unorderedListIndicatorStyle) private var unorderedStyle

    let list: ListItemContainer

    init(_ list: ListItemContainer) {
        self.list = list
    }

    var body: some View {
        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 8, verticalSpacing: nil) {
            MarkupIterator(list) { index, child in
                GridRow {
                    Group {
                        switch list {
                        case let orderedList as OrderedList:
                            AnyView(
                                orderedStyle.makeBody(
                                    configuration: ListIndicatorConfiguration(
                                        index: index,
                                        startIndex: orderedList.startIndex,
                                        level: listLevel,
                                        checked: (child as? ListItem)?.checkbox
                                    )
                                )
                            )
                        default:
                            AnyView(
                                unorderedStyle.makeBody(
                                    configuration: ListIndicatorConfiguration(
                                        index: index,
                                        startIndex: 0,
                                        level: listLevel,
                                        checked: (child as? ListItem)?.checkbox
                                    )
                                )
                            )
                        }
                    }
                    .gridColumnAlignment(.trailing)

                    Group {
                        if let markup = child as? InlineContainer {
                            InlineContainerView(markup)
                        } else {
                            VStack(alignment: .leading) {
                                MarkupView(child)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, listLevel.isRoot ? 10 : 0)
        .environment(\.listLevel, listLevel.next())
    }
}

// MARK: - Style

/// The properties of the list.
public struct ListIndicatorConfiguration {
    public let index: Int
    public let checked: Checkbox?
    public let startIndex: UInt
    public let level: ListLevel

    init(index: Int, startIndex: UInt, level: ListLevel, checked: Checkbox?) {
        self.index = index
        self.startIndex = startIndex
        self.level = level
        self.checked = checked
    }

    /// The value of the index to display
    public var displayIndex: Int {
        Int(startIndex) + index
    }
}
