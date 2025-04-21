//
//  ThematicBreakView.swift
//  MarkdownUI
//
//  Created by David Walter on 15.03.25.
//

import Markdown
import SwiftUI

struct ThematicBreakView: View {
    @Environment(\.thematicBreakStyle) private var style

    let configuration: ThematicBreakConfiguration

    init() {
        self.configuration = ThematicBreakConfiguration()
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

// MARK: - Preview

#Preview {
    MarkdownView {
        """
        Hello

        ---

        World
        """
    }
    .padding()
}
