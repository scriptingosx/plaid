//
//  plaidTestsUtility.swift
//  plaidTests
//
//  Created by Armin Briegel on 27.06.19.
//

import Foundation

enum PlaidCommandError : Error {
    case exit(code: Int32)
    case macOS1013NotAvailable
}



func runPlaidCommand(arguments: [String]) throws -> Result<String, PlaidCommandError> {
    
    // Some of the APIs that we use below are available in macOS 10.13 and above.
    guard #available(macOS 10.13, *) else {
        return .failure(.macOS1013NotAvailable)
    }
    
    let plaidBinary = productsDirectory.appendingPathComponent("plaid")
    
    let process = Process()
    process.executableURL = plaidBinary
    process.arguments = arguments
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    try process.run()
    
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    let exitCode = process.terminationStatus
    
    if exitCode == 0 {
        return .success(output)
    } else {
        return .failure(.exit(code: exitCode))
    }
}


/// Returns path to the built products directory.
var productsDirectory: URL {
    #if os(macOS)
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
        return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError("couldn't find the products directory")
    #else
    return Bundle.main.bundleURL
    #endif
}
