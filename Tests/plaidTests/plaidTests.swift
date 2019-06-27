import XCTest

final class plaidTests: XCTestCase {
    /*func testHelloWorld() throws {
        let result = try runPlaidCommand(arguments: [])
        
        switch result {
        case .success(let output):
            XCTAssertEqual(output, "Hello, world!\n")
        case .failure:
            XCTFail()
        }
    }*/

    func testVersion() throws {
        let result = try runPlaidCommand(arguments: ["version"])
        
        switch result {
        case .success(let output):
            XCTAssertEqual(output, "0.1\n")
        case .failure:
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testVersion", testVersion),
        ]
}
