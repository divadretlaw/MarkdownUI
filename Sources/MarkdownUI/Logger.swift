//
//  Logger.swift
//  MarkdownUI
//
//  Created by David Walter on 16.03.25.
//

import Foundation
import OSLog

extension Logger {
    static let text = Logger(subsystem: "at.davidwalter.markdown-ui", category: "Text")
    static let image = Logger(subsystem: "at.davidwalter.markdown-ui", category: "ImageManager")
}
