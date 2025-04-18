//
//  ImageManager.swift
//  MarkdownUI
//
//  Created by David Walter on 10.03.25.
//

import Foundation
import Observation
import Nuke
import Markdown
import OSLog

@Observable
@MainActor final class ImageManager: Sendable {
    enum Error: Swift.Error {
        case noURL
        case failure
    }

    enum State: Equatable {
        case loading(ImageTask)
        case failed
    }

    private(set) var requests: [URL: State]
    private let pipeline: ImagePipeline

    init(pipeline: ImagePipeline = .shared) {
        self.pipeline = pipeline
        self.requests = [:]
    }

    func image(for url: URL?, scale: CGFloat) -> Result<PlatformImage?, Error> {
        guard let url else {
            return .failure(.noURL)
        }

        let request = ImageRequest(url: url, processors: [.scale(scale)])

        if let response = pipeline.cache[request] {
            // Request already cached
            return .success(response.image)
        } else {
            switch requests[url] {
            case .some(.failed):
                // Request already failed
                return .failure(.failure)
            case .some:
                // Request already running. Return empty success.
                return .success(nil)
            default:
                let task = pipeline.loadImage(with: request) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success:
                        self.requests[url] = nil
                    case let .failure(error):
                        Logger.image.error("\(error.localizedDescription)")
                        self.requests[url] = .failed
                    }
                }
                requests[url] = .loading(task)
                return .success(nil)
            }
        }
    }
}

// MARK: - Nuke

extension ImageProcessors {
    fileprivate struct Scale: ImageProcessing {
        var scale: CGFloat

        func process(_ image: PlatformImage) -> PlatformImage? {
            image.scalePreservingAspectRatio(scale: scale)
        }

        func process(_ container: ImageContainer, context: ImageProcessingContext) throws -> ImageContainer {
            guard container.type != nil else {
                return container
            }
            guard let output = process(container.image) else {
                throw ImageProcessingError.unknown
            }
            var container = container
            container.image = output
            return container
        }

        var identifier: String {
            "at.davidwalter.markdown/scale?s=\(scale)"
        }

        var description: String {
            "Scale(scale: \(scale))"
        }
    }
}

extension ImageProcessing where Self == ImageProcessors.Scale {
    fileprivate static func scale(_ scale: CGFloat) -> ImageProcessors.Scale {
        ImageProcessors.Scale(scale: scale)
    }
}

// MARK: - Markdown

extension ImageManager {
    func image(for image: Markdown.Image, scale: CGFloat) -> Result<PlatformImage?, Error> {
        self.image(for: image.url, scale: scale)
    }
}

extension Markdown.Image {
    fileprivate var url: URL? {
        guard let source else { return nil }
        return URL(string: source)
    }
}
