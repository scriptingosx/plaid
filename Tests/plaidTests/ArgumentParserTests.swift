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
            XCTAssertEqual(verb, ArgumentParser.Verb.version)
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
    
    func testReadTwoArguments() {
        let filepath = productsDirectory.path + "/simple.plist"
        let fileURL = URL(fileURLWithPath: filepath)
        let keypath = "keypath"
        let additionalArguments = [keypath, filepath]
        let args = ["read"] + additionalArguments
        
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success:
            XCTAssert(parser.remainingArguments == additionalArguments)
            XCTAssert(parser.filepath == filepath, "filepath does not match")
            XCTAssert(parser.fileURL == fileURL, "fileURL does not match")
            XCTAssert(parser.keypath == keypath, "keypath does not match")
            return
        }
    }
 
    func testReadSingleArgument() {
        let filepath = productsDirectory.path + "/simple.plist"
        let fileURL = URL(fileURLWithPath: filepath)
        let additionalArguments = [filepath]
        let args = ["read"] + additionalArguments
        
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success:
            XCTAssert(parser.remainingArguments == additionalArguments)
            XCTAssert(parser.filepath == filepath, "filepath does not match")
            XCTAssert(parser.fileURL == fileURL, "fileURL does not match")
            XCTAssert(parser.keypath == nil, "keypath not nil")
            return
        }
    }
    
    func testReadNoValidFilePath() {
        let filepath = productsDirectory.path + "/nofile.plist"
        let additionalArguments = [filepath]
        let args = ["read"] + additionalArguments
        
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result {
        case .failure(let err):
            XCTAssert(err == .fileNotFound)
        case .success:
            XCTFail()
            return
        }

    }

    func testReadSingleArgumentStdin() {
        let keypath = "argument1"
        let additionalArguments = [keypath]
        let args = ["read", "--stdin"] + additionalArguments
        
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success:
            XCTAssert(parser.remainingArguments == additionalArguments)
            XCTAssert(parser.filepath == nil, "filepath not nil")
            XCTAssert(parser.keypath == keypath, "keypath does not match")
            XCTAssert(parser.options.contains(.stdin), "stdin option not parsed")
            return
        }
    }

    /*
    func testOptions() {
        let additionalArguments = ["--stdin", "--stdout"]
        let args = ["read"] + additionalArguments
        
        let parser = ArgumentParser()
        let result = parser.parse(arguments: args)
        switch result{
        case .failure:
            XCTFail()
        case .success:
            XCTAssert(parser.options == [.stdin, .stdout])
            XCTAssert(parser.remainingArguments.count == 0)
            return
        }
        
    }
    */

    static var allTests = [
        ("testVersion", testVersion),
        ("testHelp", testHelp),
        ("testNoArgs", testNoArgs),
        ("testReadTwoArguments", testReadTwoArguments),
    ]
}
