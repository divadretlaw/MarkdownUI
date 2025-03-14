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
        Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 8, verticalSpacing: lineSpacing) {
            MarkupIterator(list) { index, child in
                GridRow {
                    HStack {
                        switch list {
                        case let orderedList as OrderedList:
                            AnyView(
                                orderedStyle.makeBody(
                                    configuration: OrderedListIndicatorConfiguration(
                                        index: index,
                                        startIndex: orderedList.startIndex,
                                        level: listLevel
                                    )
                                )
                            )
                        default:
                            AnyView(
                                unorderedStyle.makeBody(
                                    configuration: UnorderedListIndicatorConfiguration(
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
                            VStack(alignment: .leading, spacing: lineSpacing) {
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
