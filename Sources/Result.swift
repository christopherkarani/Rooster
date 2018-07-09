//
//  Result.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 02/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation

// in the works
//public protocol ResultProtocol {
//
//    associatedtype Value
//    init(value: Value)
//    init(error: Error)
//    var result: Result<Value> { get}
//}
//
//extension ResultProtocol {
//    public var result: Result<() throws -> Value> {
//        switch result {
//        case .success(let value):
//            return Result(value)
//        }
//    }
//}

// lets try create a protocol for the result type


//-----------------------




/// Used to represent whether a request was successful or encountered an error.
///
/// - success: The request and all post processing operations were successful resulting in the serialization of the
///            provided associated value.
///
/// - failure: The request encountered an error resulting in a failure. The associated values are the original data
///            provided by the server as well as the error that caused the failure.
public enum Result<Value>{

    case success(Value)
    case failure(Error)
}

/// Initializers
extension Result {
    /// Initialize a succesful result with a value contained
    public init(_ value: Value) {
        self = .success(value)
    }
    
    /// Initialize a failure result with an Error contained
    public init(error: Error) {
        self = .failure(error)
    }
    
    /// A value or an Error
    public init(value: Value?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error)
        }
    }
    
    
    /// Creates a `Result` instance from the result of a closure.
    ///
    /// A failure result is created when the closure throws, and a success result is created when the closure
    /// succeeds without throwing an error.
    ///
    ///     func someString() throws -> String { ... }
    ///
    ///     let result = Result(value: {
    ///         return try someString()
    ///     })
    ///
    ///     // The type of result is Result<String>
    ///
    /// The trailing closure syntax is also supported:
    ///
    ///     let result = Result { try someString() }
    ///
    /// - parameter value: The closure to execute and create the result for.
    public init(value: () throws -> Value) {
        do {
            self = try .success(value())
        } catch {
            self = .failure(error)
        }
    }
}

extension Result: CustomStringConvertible {
    /// The debug textual representation when written to an output stream, which includes whether the result was a value or error
    public var description: String {
        switch self {
        case .success: return "Success🎉"
        case .failure: return "Failure👎🏽"
        }
    }
}

extension Result: CustomDebugStringConvertible {
    /// The debug textual representation when written to an output stream, which includes whether the result was a value or error
    public var debugDescription: String {
        switch self {
        case .success(let value): return "Success: \(value)"
        case .failure(let error): return "Failure: \(error)"
        }
    }
}

extension Result {
    ///Resturns a value if self represents a success, otherwise nil
    public var value: Value? {
        guard case .success(let v) = self else { return nil}
        return v
    }
    
    ///Returns a value if self represents an failure, otherwise nil
    public var error: Error? {
        guard case .failure(let error) = self else { return nil }
        return error
    }
    
    ///Returns a bollean representing if self is a success
    public var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }
    
     ///Returns a bollean representing if self is a failure
    public var isFailure: Bool {
        guard case .failure = self else { return false }
        return true
    }
}

extension Result {
    /// Returns the success value, or throws the failure error.
    ///
    ///     let possibleString: Result<String> = .success("success")
    ///     try print(possibleString.unwrap())
    ///     // Prints "success"
    ///
    ///     let noString: Result<String> = .failure(error)
    ///     try print(noString.unwrap())
    ///     // Throws error
    func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

// functional Extensions
extension Result {
    /// Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `map` method with a closure that does not throw. For example:
    ///
    ///     let possibleData: Result<Data> = .success(Data())
    ///     let possibleInt = possibleData.map { $0.count }
    ///     try print(possibleInt.unwrap())
    ///     // Prints "0"
    ///
    ///     let noData: Result<Data> = .failure(error)
    ///     let noInt = noData.map { $0.count }
    ///     try print(noInt.unwrap())
    ///     // Throws error
    ///
    /// - parameter transform: A closure that takes the success value of the `Result` instance.
    ///
    /// - returns: A `Result` containing the result of the given closure. If this instance is a failure, returns the
    ///            same failure.
    func map<U>(_ transform: (Value) -> U)  -> Result<U> {
        switch self {
        case .success(let value): return .success(transform(value))
        case .failure(let error): return .failure(error)
        }
    }
    
    /// Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `flatMap` method with a closure that may throw an error. For example:
    ///
    ///     let possibleData: Result<Data> = .success(Data(...))
    ///     let possibleObject = possibleData.flatMap {
    ///         try JSONSerialization.jsonObject(with: $0)
    ///     }
    ///
    /// - parameter transform: A closure that takes the success value of the instance.
    ///
    /// - returns: A `Result` containing the result of the given closure. If this instance is a failure, returns the
    ///            same failure.
    func flatMap<U>(_ transform: (Value) throws -> U) -> Result<U> {
        switch self {
        case .success(let value):
            do {
                return try .success(transform(value))
            } catch  {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}



/// Convinience method for decodable types
extension Result where Value == Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try unwrap()
        return try decoder.decode(T.self, from: data)
    }
    

    
    func encoded<T: Codable>() throws -> Result<T> {
        let decoder = JSONDecoder()
        let data = try unwrap()
        let obj = try decoder.decode(T.self, from: data)
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(obj)
        return  .success(data)
    }
}
















