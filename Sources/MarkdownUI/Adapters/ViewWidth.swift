//
//  ViewWidth.swift
//  MarkdownUI
//
//  Created by David Walter on 20.09.25.
//

import SwiftUI

// MARK: - Internal

extension View {
    func markdownViewWidth(_ value: Double?) -> some View {
        environment(\.markdownViewWidth, value)
    }
}

extension EnvironmentValues {
    @Entry var markdownViewWidth: Double? = nil
}
