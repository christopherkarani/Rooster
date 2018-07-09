

//
//  Rooster.swift
//  C.K
//
//  Created by Christopher Karani on 03/06/2018.
//  Copyright © 2018 C.K. All rights reserved.
//

import Foundation

public final class Roost<R: Resource> {
    func load(_ resource: R, completion: @escaping (Result<R.T>) -> ()) {
        let request = URLRequest(resource: resource)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<R.T>
            if let httpResponse = response as? HTTPURLResponse {
                let code =  HTTPStatusCode(statusCode:  httpResponse.statusCode)
                result = Result(error: RoostError.statusCodeError(code.statusDescription))
            } else {
                let parsed = data.flatMap (resource.parse)
                result = Result(value: parsed, or: RoostError.other)
            }
            DispatchQueue.main.async { completion(result) }
            }.resume()
    }
}
