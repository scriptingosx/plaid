//
//  main.swift
//  plaid
//
//  Created by Armin Briegel on 27.06.19.
//

import Foundation

let version = "0.1"

func printUsage() {
    print("""
plaid - a tool to manipulate property list files

Usage: plaid verb [keypath] filepath

where verb is one of the following:
    version     prints the version of the tool
    help        shows this output
    read        prints the contents of the property list at filepath
    write
    delete
    add
    export      
""")
}

func readPlist(url: Foundation.URL) -> Any? {
    if let xmlData = FileManager.default.contents(atPath: url.path) {
        if let plist = try? PropertyListSerialization.propertyList(from: xmlData, format: nil) {
            return plist
        }
    }
    return nil
}

func readPlistFromStdin() -> Any? {
    let stdin = FileHandle.standardInput
    let xmlData = stdin.readDataToEndOfFile()
    if let plist = try? PropertyListSerialization.propertyList(from: xmlData, format: nil ) {
        return plist
    }
    return nil
}

let args = Array(CommandLine.arguments.dropFirst())
let parser = ArgumentParser()
let result = parser.parse(arguments: args)

switch result {
case .failure(let parseError):
    print("Error \(parseError)")
    exit(1)
case .success(let verb):
    switch verb {
    case .version:
        print(version)
    case .help:
        printUsage()
    case .read:
        let plist = PropertyListFile(url: parser.fileURL!)
        if plist.rootObject == nil {
            print("could not read \(parser.filepath ?? "<none>")")
        } else {
            if (parser.keypath == nil) {
                print(plist.rootObject!)
            } else {
                if let value = plist.rootObject!.value(forKeyPath: parser.keypath!) {
                    print(value)
                } else {
                    print("no key \(parser.keypath!) in \(parser.filepath!)")
                }
            }
        }
        
    default:
        print(verb.rawValue)
    }
}
