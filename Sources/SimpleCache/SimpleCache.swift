import Foundation

public final class SimpleCache {
    public typealias ResourceLoader = (URL, @escaping (Data?) -> Void) -> Void

    private var cache: [URL: Data] = [:]
    private let resourceLoader: ResourceLoader

    public init(resourceLoader: @escaping ResourceLoader) {
        self.resourceLoader = resourceLoader
    }

    public func get(_ url: URL, completion: @escaping (Data?) -> Void) {
        if let data = cache[url] {
            completion(data)
        } else {
            resourceLoader(url) { [weak self] data in
                self?.cache[url] = data
                completion(data)
            }
        }
    }
}

public extension SimpleCache {
    static func make(resourceLoader: ResourceLoader?) -> SimpleCache {
        if let resourceLoader = resourceLoader {
            return SimpleCache(resourceLoader: resourceLoader)
        } else {
            return SimpleCache(resourceLoader: { url, completion in
                let configuration = URLSessionConfiguration.ephemeral
                let session = URLSession(configuration: configuration)

                let task = session.dataTask(with: url) { data, response, error in
                    completion(data)
                }
                task.resume()
            })
        }
    }
}
