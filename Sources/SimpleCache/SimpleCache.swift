import Foundation
import AsyncHTTPClient

public final class SimpleCache {
    public var numberOfCaches = 100

    private let cache: LRUCache
    private let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)

    init() {
        self.cache = LRUCache(numberOfCaches: numberOfCaches)
    }
    deinit {
        try? httpClient.syncShutdown()
    }

    public func get(_ url: URL, completion: @escaping (Data?) -> Void) {
        if let data = cache.get(url) {
            completion(data)
        } else {
            if let request = try? HTTPClient.Request(url: url.absoluteString, method: .GET) {
                httpClient.execute(request: request).whenComplete { [weak self] result in
                    switch result {
                    case .failure(let error): print(error)
                    case .success(var response):
                        if response.status == .ok {
                            let length = response.body?.readableBytes ?? 0
                            let data = response.body?.readData(length: length)
                            completion(data)
                            if let data = data {
                                self?.cache.set(url, data: data)
                            }
                        }
                    }
                }
            }
        }
    }
}
