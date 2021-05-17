//
//  ImageLoader.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/14.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

//struct ImageView: View {
//    @ObservedObject var imageLoader:ImageLoader
//    @State var image:UIImage = UIImage()
//
//    init(withURL url:String) {
//        imageLoader = ImageLoader(urlString:url)
//    }
//
//    var body: some View {
//
//            Image(uiImage: image)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width:100, height:100)
//                .onReceive(imageLoader.didChange) { data in
//                self.image = UIImage(data: data) ?? UIImage()
//        }
//    }
//}

//struct AsyncImage<Placeholder: View>: View {
//    @StateObject private var loader: ImageLoader
//    private let placeholder: Placeholder
//    private let image: (UIImage) -> Image
//
//    init(
//        url: URL,
//        @ViewBuilder placeholder: () -> Placeholder,
//        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
//    ) {
//        self.placeholder = placeholder()
//        self.image = image
//        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
//    }
//
//    var body: some View {
//        content
//            .onAppear(perform: loader.load)
//    }
//
//    private var content: some View {
//        Group {
//            if loader.image != nil {
//                image(loader.image!)
//            } else {
//                placeholder
//            }
//        }
//    }
//}
//
//protocol ImageCache {
//    subscript(_ url: URL) -> UIImage? { get set }
//}
//
//struct TemporaryImageCache: ImageCache {
//    private let cache = NSCache<NSURL, UIImage>()
//
//    subscript(_ key: URL) -> UIImage? {
//        get { cache.object(forKey: key as NSURL) }
//        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
//    }
//}
//
//class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//
//    private(set) var isLoading = false
//
//    private let url: URL
//    private var cache: ImageCache?
//    private var cancellable: AnyCancellable?
//
//    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
//
//    init(url: URL, cache: ImageCache? = nil) {
//        self.url = url
//        self.cache = cache
//    }
//
//    deinit {
//        cancel()
//    }
//
//    func load() {
//        guard !isLoading else { return }
//
//        if let image = cache?[url] {
//            self.image = image
//            return
//        }
//
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: nil)
//            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
//                          receiveOutput: { [weak self] in self?.cache($0) },
//                          receiveCompletion: { [weak self] _ in self?.onFinish() },
//                          receiveCancel: { [weak self] in self?.onFinish() })
//            .subscribe(on: Self.imageProcessingQueue)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in self?.image = $0 }
//    }
//
//    func cancel() {
//        cancellable?.cancel()
//    }
//
//    private func onStart() {
//        isLoading = true
//    }
//
//    private func onFinish() {
//        isLoading = false
//    }
//
//    private func cache(_ image: UIImage?) {
//        image.map { cache?[url] = $0 }
//    }
//}
//
//struct ImageCacheKey: EnvironmentKey {
//    static let defaultValue: ImageCache = TemporaryImageCache()
//}
//
//extension EnvironmentValues {
//    var imageCache: ImageCache {
//        get { self[ImageCacheKey.self] }
//        set { self[ImageCacheKey.self] = newValue }
//    }
//}
