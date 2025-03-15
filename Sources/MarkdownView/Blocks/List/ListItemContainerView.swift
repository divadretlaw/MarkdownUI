//
//  ListItemContainerView.swift
//  MarkdownView
//
//  Created by David Walter on 14.03.25.
//

import SwiftUI
import Markdown

struct ListItemContainerView: View {
    @Environment(\.markdownLineSpacing) private var lineSpacing
    @Environment(\.markdownListLevel) private var listLevel
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
                    HStack {
                        switch list {
                        case let orderedList as OrderedList:
                            AnyView(
                                orderedStyle.makeBody(
                                    configuration: ListIndicatorConfiguration(
                                        index: index,
                                        startIndex: orderedList.startIndex,
                                        level: listLevel
                                    )
                                )
                            )
                        default:
                            AnyView(
                                unorderedStyle.makeBody(
                                    configuration: ListIndicatorConfiguration(
                                        index: index,
                                        startIndex: 0,
                                        level: listLevel
                                    )
                                )
                            )
                        }
                        
                        if let listItem = child as? ListItem, let checked = listItem.checkbox {
                            switch checked {
                            case .checked:
                                Image(systemName: "checkmark.circle.fill")
                            case .unchecked:
                                Image(systemName: "circle")
                                    .foregroundStyle(.secondary)
                            }
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
        .environment(\.markdownListLevel, listLevel.next())
    }
}

// MARK: - Style

public struct ListIndicatorConfiguration {
    public let index: Int
    public let startIndex: UInt
    public let level: ListLevel
    
    init(index: Int, startIndex: UInt, level: ListLevel) {
        self.index = index
        self.startIndex = startIndex
        self.level = level
    }
}
