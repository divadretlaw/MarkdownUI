//
//  Image+Extensions.swift
//  MarkdownView
//
//  Created by David Walter on 11.03.25.
//

import SwiftUI
import ImageIO

#if os(iOS) || targetEnvironment(macCatalyst) || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit

extension UIImage {
    func scalePreservingAspectRatio(scale: CGFloat) -> UIImage {
        let scaleFactor = 1.0 / scale
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        #if os(watchOS)
        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        // Draw and return the resized UIImage
        self.draw(in: CGRect(
            origin: .zero,
            size: scaledImageSize
        ))

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
        #else
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        return renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        #endif
    }
}
#endif

#if os(macOS)
import AppKit

extension NSImage {
    convenience init?(systemName: String) {
        self.init(systemSymbolName: systemName, accessibilityDescription: systemName)
    }
    
    func scalePreservingAspectRatio(scale: CGFloat) -> NSImage {
        let scaleFactor = 2.0 / scale

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        return NSImage(size: scaledImageSize, flipped: false) { rect in
            self.draw(in: rect)
            return true
        }
    }
    
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
    }
}
#endif
