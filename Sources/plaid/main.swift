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
    write       -not yet-
    delete      -not yet-
""")
}

func printObject(_ object: NSObject, options: [ArgumentParser.Options] = []) {
    if options.contains(.xml) {
        let xmldata = try? PropertyListSerialization.data(fromPropertyList: object, format: .xml, options: 0)
        let plistText = String(data: xmldata!, encoding: .utf8)
        print(plistText ?? "<no value>")
    }  else {
        print(object)
    }

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
        var plist : PropertyListFile?
        if parser.options.contains(.stdin) {
            plist = PropertyListFile(url: nil)
        } else {
            plist = PropertyListFile(url: parser.fileURL)
        }
        if plist?.rootObject == nil {
            print("could not read \(parser.filepath ?? "<none>")")
            exit(1)
        } else {
            var object = plist?.rootObject!
            if (parser.keypaths.count == 0) {
                printObject(object!, options: parser.options)
            } else {
                for keypath in parser.keypaths {
                    guard let newobject = object!.value(forKeyPath: keypath!) else {
                        print("no key \(String(describing: keypath!)) in \(String(describing: object!))")
                        exit(1)
                    }
                    object = newobject as? NSObject
                }
                printObject(object!, options: parser.options)
            }
        }
    }
}
