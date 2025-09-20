//
//  ImageManager.swift
//  MarkdownUI
//
//  Created by David Walter on 10.03.25.
//

import Foundation
import Observation
import Markdown
import OSLog

@MainActor
@Observable
final class ImageManager: Sendable {
    enum Error: Swift.Error {
        case noURL
        case failure
    }

    enum State: Equatable {
        case loading(Task<Void, Never>)
        case failed
    }

    private(set) var requests: [URL: State]
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(
            memoryCapacity: 100 * 1024 * 1024,  // 100 MB
            diskCapacity: 200 * 1024 * 1024,  // 200 MB
            diskPath: "markdownUI"
        )
        self.session = URLSession(configuration: configuration)
        self.requests = [:]
    }

    func image(for url: URL?, scale: CGFloat) -> Result<PlatformImage?, Error> {
        guard let url else { return .failure(.noURL) }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        if let cache = session.configuration.urlCache, let response = cache.cachedResponse(for: request) {
            let image = PlatformImage(data: response.data)
            return .success(image?.scalePreservingAspectRatio(scale: scale))
        } else {
            switch requests[url] {
            case .some(.failed):
                // Request already failed
                return .failure(.failure)
            case .some:
                // Request already running. Return empty success.
                return .success(nil)
            default:
                let task = Task {
                    do {
                        // Load the url to so it will be cached
                        let _ = try await session.data(from: url)
                        self.requests[url] = nil
                    } catch {
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
