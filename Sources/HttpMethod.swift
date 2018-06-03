//
//  HttpMethod.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 02/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod: CustomStringConvertible {
    /// returns the textual debug representation of HttpMethod, and wether or not the value is a post
    /// or get
    var description: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

extension HttpMethod: CustomDebugStringConvertible {
    /// returns the textual debug representation of HttpMethod, and wether or not the value is a post
    /// or get, and the associated value inside post or simple get.
    var debugDescription: String {
        switch self {
        case .get: return "GET"
        case .post(let body): return "POST: \(body)"
        }
    }
}

extension HttpMethod {
    /// Maps over HttpMethod, this method either returns .get or returns .post(Data) that can be
    /// Transformed on the call site
    func map<R>(_ transform: (Body) throws -> R) rethrows -> HttpMethod<R> {
        guard case .post(let body) = self else { return .get }
        return .post(try transform(body))
    }
}
