//
//  DefaultHeadingStyle.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import SwiftUI

public struct DefaultHeadingStyle: HeadingStyle {
    /// Required by Swift 5 language mode
    nonisolated init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(.vertical, 8)

    }
}

extension HeadingStyle where Self == DefaultHeadingStyle {
    public static var `default`: DefaultHeadingStyle {
        DefaultHeadingStyle()
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
    .markdownHeadingStyle(.default)
}
