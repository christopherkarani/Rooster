//
//  Resource.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 02/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation


/// `Resource` protocol defined how to download and cache a resource from the network
public protocol Resource {
    /// target Url
    var url: URL { get }
    
    /// The `HttpMethod` are our Http verbs used inside Rooster
    var method: HttpMethod<Data> { get }
    
    associatedtype T
    
    /// Transformation on some data returning a type T
    var parse : (Data) -> T? { get }
}

extension Resource {
    /// The Key used in the cache
    var cacheKey: String {
        return "cache" + "\(url.hashValue)" //TODO use sha1
    }
}

/// A Resource for retriving Images
struct ImageResource<UIImage>: Resource {
    let url: URL
    var method: HttpMethod<Data>
    var parse: (Data) -> UIImage?
}

///
struct CodableResource<T: Codable>: Resource {
    let url: URL
    var method: HttpMethod<Data>
    var parse: (Data) -> T?
}

struct JSONResource<T>: Resource {
    var url: URL
    var method: HttpMethod<Data>
    var parse: (Data) -> T?
}

extension JSONResource {
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

extension CodableResource where T: Codable {
    /// An initializer for decodable Types
    init(url: URL) {
        self.init(url: url, method: .get) { data in
            return try! JSONDecoder().decode(T.self, from: data)
        }
    }
    
    /// An Initializer for encodable types, used for post resources
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




