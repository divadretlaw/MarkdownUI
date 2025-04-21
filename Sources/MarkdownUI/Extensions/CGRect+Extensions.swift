//
//  CGRect+Extensions.swift
//  MarkdownUI
//
//  Created by David Walter on 21.04.25.
//

import Foundation

extension [CGRect] {
    func joinedWidth() -> CGRect? {
        let x = map(\.origin.x).min() ?? 0
        let y = map(\.origin.y).min() ?? 0
        let width = map(\.size.width).reduce(into: 0) { partialResult, next in
            partialResult += next
        }
        let height = map(\.size.height).max() ?? 0
        return CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
    }
}
