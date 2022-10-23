import XCTest
@testable import SimpleCache

final class SimpleCacheTests: XCTestCase {
    func testGet() throws {
        let expectGet = expectation(description: #function)
        let expectGetCache = expectation(description: #function)
        
        let url = URL(string: "https://cdn.vox-cdn.com/verge/favicon.ico")
        let sut = SimpleCache()

        let unwrapURL = try XCTUnwrap(url)
        sut.get(unwrapURL) { data in
            XCTAssertNotNil(data)
            expectGet.fulfill()
        }
        wait(for: [expectGet], timeout: 1)
        
        sut.get(unwrapURL) { data in
            XCTAssertNotNil(data)
            expectGetCache.fulfill()
        }
        wait(for: [expectGetCache], timeout: 1)
    }
}
