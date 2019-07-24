//
//  ArgumentParser.swift
//  plaid
//
//  Created by Armin Briegel on 27.06.19.
//

import Foundation

class ArgumentParser {
    
    enum Verb : String {
        case version
        case help
        case read
        case write
        case delete
        case export
    }
    
    enum Options : String {
        case stdin
        case stdout
    }
    
    enum ParserError : Error {
        case noArguments
        case notEnoughArguments
        case tooManyArguments
        case fileNotFound
        case unknownVerb
        case unknownOption
    }
    
    var verb : Verb?
    var options : [Options] = []
    var remainingArguments : [String] = []
    var keypaths : [String?] = []
    var value : String?
    var filepath : String?
    var fileURL : URL?
    
    func parseURL(path : String) -> URL? {
        let fm = FileManager.default
        let cwd = URL(fileURLWithPath: fm.currentDirectoryPath)
        let url = URL(fileURLWithPath: path, relativeTo: cwd)
        if fm.fileExists(atPath: url.path) {
            return url
        } else {
            return nil
        }
    }

    
    // usage is: plaid verb [keypath] filepath
    func parse(arguments: [String]) -> Result<Verb, ParserError> {
        let c = arguments.count
        
        if c == 0 {
            return .failure(.noArguments)
        }
        
        // we have at least one argument, it should be a verb
        guard let v = Verb(rawValue: arguments[0]) else {
            print("unknown verb: \(arguments[0])")
            return .failure(.unknownVerb)
        }
        verb = v
        
        // search for options that start with `-` or `--`
        for argument in arguments.dropFirst() {
            
            if argument.starts(with: "-") {
                // remove leading dashes
                let trimmedArgument = String(argument.drop(while: {$0 == "-"}))
                guard let option = Options(rawValue: trimmedArgument) else {
                    return .failure(.unknownOption)
                }
                options.append(option)
            } else {
                remainingArguments.append(argument)
            }
        }
        
        // interpretation of the remaining arguments depends on the verb
        switch verb! {
        case .version, .help:
            if remainingArguments.count > 0 {
                return .failure(.tooManyArguments)
            } 
        case .read:
            if !options.contains(.stdin) {
                if remainingArguments.count == 0 {
                    return .failure(.notEnoughArguments)
                } else {
                    // last argument is filepath
                    filepath = remainingArguments.last
                    keypaths = remainingArguments.dropLast()
                }
                fileURL = parseURL(path: filepath!)
                if fileURL == nil {
                    return .failure(.fileNotFound)
                }
            } else { // read from stdin
                keypaths = remainingArguments
            }
        default:
            break
        }
        
        return .success(verb!)
    }
}
