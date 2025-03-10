//
//  MarkdownListLevel.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

private struct MarkdownListLevelKey: EnvironmentKey {
    static let defaultValue: ListLevel = .root
}

extension EnvironmentValues {
    var markdownListLevel: ListLevel {
        get { self[MarkdownListLevelKey.self] }
        set { self[MarkdownListLevelKey.self] = newValue }
    }
}
