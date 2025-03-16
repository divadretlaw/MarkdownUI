//
//  ListLevel.swift
//  MarkdownUI
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

/// The level of indentation of a Markdown list
public enum ListLevel: RawRepresentable, Sendable {
    /// The root level
    case root
    /// The level following root
    case indented
    /// All other levels
    case furtherIndented(_ level: Int)
    
    // MARK: - RawRepresentable
    
    public init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .root
        case 1:
            self = .indented
        default:
            self = .furtherIndented(rawValue)
        }
    }
    
    public var rawValue: Int {
        switch self {
        case .root:
            0
        case .indented:
            1
        case let .furtherIndented(value):
            value
        }
    }
    
    // MARK: - Helper
    
    /// Check if this level represents the root of the list
    public var isRoot: Bool {
        self == .root
    }
    
    func next() -> Self {
        ListLevel(rawValue: rawValue + 1)
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry var listLevel: ListLevel = .root
}
