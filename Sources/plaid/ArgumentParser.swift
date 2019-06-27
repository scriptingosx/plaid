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
    }
    
    enum ParserError : Error {
        case noArguments
        case tooManyArguments
        case unknownVerb
    }
    
    var verb : Verb?
    var keypath : String?
    var filepath : String?
    var fileURL : URL?
        
    // usage is: plaid verb [keypath] filepath
    func parse(arguments: [String]) -> Result<Verb?, ParserError> {
        let c = arguments.count
        
        if c == 0 {
            return .failure(.noArguments)
        } else if c > 3 {
            return .failure(.tooManyArguments)
        }
        // we have at least one argument, it should be a verb
        
        guard let v = Verb(rawValue: arguments[0]) else {
            print("unknown verb: \(arguments[0])")
            return .failure(.unknownVerb)
        }
        verb = v
        
        if c == 2 {
            filepath = arguments[1]
        } else if c == 3 {
            filepath = arguments[2]
            keypath = arguments[3]
        }
        
        // parse the file path
        
        return .success(verb)
    }
}
