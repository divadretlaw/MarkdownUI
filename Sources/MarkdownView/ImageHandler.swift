//
//  ImageHandler.swift
//  MarkdownView
//
//  Created by David Walter on 10.03.25.
//

import SwiftUI
import Observation
import Nuke
import Markdown

@Observable
@MainActor final class ImageHandler {
    enum Error: Swift.Error {
        case noURL
    }
    
    static let shared = ImageHandler()
    
    var loadingTasks: [URL: ImageTask]

    init() {
        loadingTasks = [:]
    }
    
    func image(for url: URL?, scale: CGFloat) -> Result<PlatformImage?, Error> {
        guard let url else {
            return .failure(.noURL)
        }
        
        let request = ImageRequest(url: url)
        if let response = ImagePipeline.shared.cache[request] {
            return .success(response.image)
        } else {
            // Create image loading task
            let task = ImagePipeline.shared.loadImage(with: request) { [unowned self] result in
                // Image loading task finished, remove task to force refresh
                self.loadingTasks[url] = nil
            }
            self.loadingTasks[url] = task
            return .success(nil)
        }
    }
    
    func image(for image: Markdown.Image, scale: CGFloat) -> Result<PlatformImage?, Error> {
        self.image(for: image.url, scale: scale)
    }
}

private extension Markdown.Image {
    var url: URL? {
        guard let source else { return nil }
        return URL(string: source)
    }
}
