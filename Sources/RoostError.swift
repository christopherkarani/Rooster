//
//  RoostError.swift
//  Rooster-iOS
//
//  Created by Christopher Brandon Karani on 02/07/2018.
//  Copyright © 2018 C.K. All rights reserved.
//

import Foundation


enum RoostError: Error {
    case notAuthenticated
    case other
    case general(String)
    case statusCodeError(String)
}

func logError<A>(_ result: Result<A>) {
    guard case .failure(let e) = result else { return }
    assert(false, "\(e)")
}
