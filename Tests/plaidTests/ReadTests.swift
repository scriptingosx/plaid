//
//  ReadTests.swift
//  plaidTests
//
//  Created by Armin Briegel on 24.07.19.
//

import XCTest

final class ReadTests: XCTestCase {
    func testReadWholeFile() {
        let filepath = productsDirectory.path + "/singleKeyDict.plist"
        let args = ["read", filepath]
        guard let result = try? runPlaidCommand(arguments: args) else {
            XCTFail()
            return
        }
        switch result {
        case .failure:
            XCTFail()
        case .success(let output):
            XCTAssertEqual(output, """
{
    singleKey = "Single Value";
}

""")
        }
    }
    
    func testReadSingleKey() {
        let filepath = productsDirectory.path + "/singleKeyDict.plist"
        let keypath = "singleKey"
        let args = ["read", keypath, filepath]
        guard let result = try? runPlaidCommand(arguments: args) else {
            XCTFail()
            return
        }
        switch result {
        case .failure:
            XCTFail()
        case .success(let output):
            XCTAssertEqual(output, "Single Value\n")
        }
    }
    
    func testReadArrayIndex() {
        let filepath = productsDirectory.path + "/singleItemArray.plist"
        let keypath = "@index.0"
        let args = ["read", keypath, filepath]
        guard let result = try? runPlaidCommand(arguments: args) else {
            XCTFail()
            return
        }
        switch result {
        case .failure:
            XCTFail()
        case .success(let output):
            XCTAssertEqual(output, "one\n")
        }
    }


}
