//
//  File.swift
//  MarkdownView
//
//  Created by David Walter on 10.03.25.
//

import SwiftUI
import Nuke
import Markdown
import Combine

@MainActor final class ImageHandler: ObservableObject {
    static let shared = ImageHandler()
    
    @Published var uuid: UUID
    @Published var loadingTasks: [URL: ImageTask]
    private var cancellables: [AnyCancellable]
    
    init() {
        uuid = UUID()
        loadingTasks = [:]
        cancellables = []
        
        $loadingTasks
            .sink { _ in
                self.uuid = UUID()
            }
            .store(in: &cancellables)
    }
    
    func image(for url: URL?, scale: CGFloat) -> SwiftUI.Text {
        guard let url else {
            return SwiftUI.Text("\(Image(systemName: "photo.badge.exclamationmark"))")
        }
        
        let request = ImageRequest(url: url)
        if let image = ImagePipeline.shared.cache[request] {
            // Return cached image wrapped in 'Text'
            return SwiftUI.Text("\(Image(uiImage: image.image))")
        } else {
            // Create image loading task
            let task = ImagePipeline.shared.loadImage(with: request) { [unowned self] result in
                // Image loading task finished, remove task to force refresh
                self.loadingTasks[url] = nil
            }
            self.loadingTasks[url] = task
            // Return placeholder wrapped in 'Text'
            return SwiftUI.Text("\(Image(systemName: "photo.badge.arrow.down"))")
        }
    }
    
    func image(for image: Markdown.Image, scale: CGFloat) -> SwiftUI.Text {
        self.image(for: image.url, scale: scale)
    }
}

private extension Markdown.Image {
    var url: URL? {
        guard let source else { return nil }
        return URL(string: source)
    }
}
