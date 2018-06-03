//
//  FileStorage.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 03/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation


struct FileStorage {
    let baseUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript (key: String) -> Data? {
        get {
            let url = baseUrl.appendingPathComponent(key)
            return try? Data(contentsOf: url)
        }
        set {
            let url = baseUrl.appendingPathComponent(key)
            return _ = try? newValue?.write(to: url)
        }
    }
}
