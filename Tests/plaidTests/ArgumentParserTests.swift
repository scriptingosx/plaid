//
//  ArgumentParserTests.swift
//  plaid
//
//  Created by Armin Briegel on 27.06.19.
//

import XCTest

final class ArgumentParserTests: XCTestCase {
    func testVersion() {
        let args = ["version"]
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success(let verb):
            XCTAssertEqual(verb!, ArgumentParser.Verb.version)
        }
    }
    
    func testNoArgs() {
        let args = [String]()
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            return
        case .success:
            XCTFail()
        }

    }
    
    func testHelp() {
        let args = ["help"]
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success:
            return
        }

    }
    
    static var allTests = [
        ("testVersion", testVersion),
        ("testHelp", testHelp),
        ("testNoArgs", testNoArgs)
    ]
}
