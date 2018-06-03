//
//  Resource.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 02/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

/// struct that specifies the endpoint's URL as well as a parsing function that can turn the data from the network into a result with a specific type
///   budles up information about the endpoint and parse data into type T
/// - url: The Url endpoint
/// - parse: The transformation function done on data
struct Resource<T> {
    let url: URL
    let method: HttpMethod<Data>
    let parse : (Data) -> T?
}

extension Resource {
    ///  initializer that  defaults HttpMethod to `get`, also parses Any Instead of Data
    ///  for convenience purposes
    init(url: URL, parseJSON: @escaping (Any) -> T)  {
        self.url = url
        self.method = .get
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
    
    /// An initializer for Post resources, This initializer expects JSON for parsing
    /// - url: The Endpoint URL
    /// - method: The HttpMethod to be used.
    /// - parseJson: The transformation don on object to json
    init(_ url: URL, method: HttpMethod<Any>, parseJSON: @escaping (Any) -> T) throws {
        self.url = url
        self.method = try method.map { json in
           try JSONSerialization.data(withJSONObject: json, options: [])
        }
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

extension Resource where T: Decodable {
    /// An initializer for decodable Types
    init(url: URL) {
        self.init(url: url, method: .get) { data in
            return try! JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension Resource where T: Codable {
    // An Initializer for encodable types, used for post resources
    init(url: URL, method: HttpMethod<Data>, parseEncodable: @escaping (Data) -> T) {
        self.url = url
        self.method =  method.map { data in
            let decoded = try! JSONDecoder().decode(T.self, from: data)
            let encoded = try! JSONEncoder().encode(decoded)
            return encoded
        }
        self.parse =  { data in
            return try! JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension Resource {
    var cacheKey: String {
        return "cache" + "\(url.hashValue)" //TODO use sha1
    }
}

