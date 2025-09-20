//
//  OptionSet+Extensions.swift
//  MarkdownUI
//
//  Created by David Walter on 20.09.25.
//

import Foundation

extension Array where Element: OptionSet {
    func joined() -> Element? {
        guard var result = first else { return nil }
        for option in self.dropFirst() {
            result.formUnion(option)
        }
        return result
    }
}
