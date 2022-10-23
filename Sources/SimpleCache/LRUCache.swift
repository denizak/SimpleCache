import Foundation
final class LRUCache {
    private var cache: [URL: Data] = [:]
    private var recentURL: [URL] = []

    private let numberOfCaches: Int
    init(numberOfCaches: Int) {
        self.numberOfCaches = numberOfCaches
    }

    func get(_ url: URL) -> Data? {
        updateRecent(url)
        return cache[url]
    }

    func set(_ url: URL, data: Data) {
        cache[url] = data
        updateRecent(url)

        if recentURL.count > numberOfCaches {
            let lastURL = recentURL.removeLast()
            cache.removeValue(forKey: lastURL)
        }
    }

    private func updateRecent(_ url: URL) {
        if let index = recentURL.firstIndex(of: url) {
            recentURL.remove(at: index)
        }
        recentURL.insert(url, at: 0)
    }
}
