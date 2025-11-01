//
//  Typealiases.swift
//  MarkdownUI
//
//  Created by David Walter on 20.09.25.
//

import Foundation

#if os(iOS) || targetEnvironment(macCatalyst) || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit

/// Platform indepdendent image alias. Will be `UIImage`.
public typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit

/// Platform indepdendent image alias. Will be `NSImage`.
public typealias PlatformImage = NSImage
#else
#error("Unsupported platform")
#endif
