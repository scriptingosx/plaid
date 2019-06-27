import XCTest
import class Foundation.Bundle

final class plaidTests: XCTestCase {
    func testHelloWorld() throws {
        let result = try runPlaidCommand(arguments: [])
        
        switch result {
        case .success(let output):
            XCTAssertEqual(output, "Hello, world!\n")
        case .failure:
            XCTFail()
        }
    }

    static var allTests = [
        ("testHelloWorld", testHelloWorld),
    ]
}
