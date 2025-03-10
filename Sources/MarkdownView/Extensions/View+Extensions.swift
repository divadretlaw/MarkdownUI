//
//  View+Extensions.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        modifier(HiddenViewModifier(isHidden: isHidden))
    }
}

struct HiddenViewModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}
