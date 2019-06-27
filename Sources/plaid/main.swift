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
""")
}

let args = Array(CommandLine.arguments.dropFirst())
let parser = ArgumentParser()
let result = parser.parse(arguments: args)

switch result {
case .failure(let parseError):
    printUsage()
    exit(1)
case .success(let verb):
    if verb != nil {
        switch verb! {
        case .version:
            print(version)
        case .help:
            printUsage()
        case .read:
            print("read")
        }
    }
}
