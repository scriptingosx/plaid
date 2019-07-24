//
//  PropertyListFile.swift
//  plaid
//
//  Created by Armin Briegel on 24.07.19.
//

import Foundation


class PropertyListFile {
    var url : URL?
    var rootObject : NSObject?
    
    init(url: URL?) {
        if url == nil {
            readFromStdin()
        } else {
            read(url: url!)
        }
    }
    
    
    func read(url: Foundation.URL) {
        if let xmlData = FileManager.default.contents(atPath: url.path) {
            if let plist = try? PropertyListSerialization.propertyList(from: xmlData, format: nil) {
                rootObject = plist as? NSObject
            }
        }
    }
    
    func readFromStdin() {
        let stdin = FileHandle.standardInput
        let xmlData = stdin.readDataToEndOfFile()
        if let plist = try? PropertyListSerialization.propertyList(from: xmlData, format: nil ) {
            rootObject = plist as? NSObject
        }
    }
}
