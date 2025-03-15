//
//  MarkdownLineSpacingKey.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

private struct MarkdownLineSpacingKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    var markdownLineSpacing: CGFloat? {
        get { self[MarkdownLineSpacingKey.self] }
        set { self[MarkdownLineSpacingKey.self] = newValue }
    }
}
