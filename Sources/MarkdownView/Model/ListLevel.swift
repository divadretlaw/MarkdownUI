//
//  ListLevel.swift
//  MarkdownView
//
//  Created by David Walter on 09.03.25.
//

import SwiftUI

enum ListLevel: RawRepresentable {
    case root
    case one
    case more(_ level: Int)
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .root
        case 1:
            self = .one
        default:
            self = .more(rawValue)
        }
    }
    
    var rawValue: Int {
        switch self {
        case .root:
            0
        case .one:
            1
        case let .more(value):
            value
        }
    }
    
    var isRoot: Bool {
        self == .root
    }
    
    func next() -> ListLevel {
        switch self {
        case .root:
            return .one
        case .one:
            return .more(2)
        case let .more(value):
            return .more(value + 1)
        }
    }
}
