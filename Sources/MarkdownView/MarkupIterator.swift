//
//  MarkupIterator.swift
//  MarkdownView
//
//  Created by David Walter on 14.03.25.
//

import SwiftUI
import Markdown

struct MarkupIterator<Content>: View where Content: View {
    let markup: Markup
    let content: (Int, Markup) -> Content
    
    init(_ markup: Markup, @ViewBuilder content: @escaping (_ child: Markup) -> Content) {
        self.markup = markup
        self.content = { _, child in
            content(child)
        }
    }
    
    init(_ markup: Markup, @ViewBuilder content: @escaping (_ index: Int, _ child: Markup) -> Content) {
        self.markup = markup
        self.content = content
    }
    
    var body: some View {
        ForEach(0..<markup.childCount, id: \.self) { index in
            if let child = markup.child(at: index) {
                content(index, child)
            }
        }
    }
}
