//
//  ImageManager.swift
//  MarkdownView
//
//  Created by David Walter on 10.03.25.
//

import Foundation
import Observation
import Nuke
import Markdown

@Observable
@MainActor final class ImageManager {
    enum Error: Swift.Error {
        case noURL
    }
    
    var loadingTasks: [URL: ImageTask]
    
    private let pipeline: ImagePipeline

    init(pipeline: ImagePipeline = .shared) {
        self.pipeline = pipeline
        self.loadingTasks = [:]
    }
    
    func image(for url: URL?, scale: CGFloat) -> Result<PlatformImage?, Error> {
        guard let url else {
            return .failure(.noURL)
        }
        
        let request = ImageRequest(url: url, processors: [.scale(scale)])
        if let response = pipeline.cache[request] {
            return .success(response.image)
        } else {
            // Create image loading task
            let task = pipeline.loadImage(with: request) { [weak self] _ in
                guard let self else { return }
                // Image loading task finished, remove task to force refresh
                self.loadingTasks[url] = nil
            }
            self.loadingTasks[url] = task
            return .success(nil)
        }
    }
}

// MARK: - Nuke

private extension ImageProcessors {
    struct Scale: ImageProcessing {
        var scale: CGFloat
        
        func process(_ image: PlatformImage) -> PlatformImage? {
            image.scalePreservingAspectRatio(scale: scale)
        }
        
        public var identifier: String {
            "at.davidwalter.markdown/scale?s=\(scale)"
        }

        public var description: String {
            "Scale(scale: \(scale))"
        }
    }
}

private extension ImageProcessing where Self == ImageProcessors.Scale {
    static func scale(_ scale: CGFloat) -> ImageProcessors.Scale {
        ImageProcessors.Scale(scale: scale)
    }
}

// MARK: - Markdown

extension ImageManager {
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
