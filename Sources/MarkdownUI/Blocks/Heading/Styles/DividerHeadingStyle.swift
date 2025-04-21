//
//  DividerHeadingStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

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

// MARK: - Preview

#Preview {
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
