//
//  CachedWebService.swift
//  NetworkLibrary
//
//  Created by Christopher Brandon Karani on 03/06/2018.
//  Copyright © 2018 Christopher Brandon Karani. All rights reserved.
//

import Foundation
/**
 
 The idea behind the CachedWebservice class is to maintain a separation of concerns: the Webservice should only be concerned with executing network requests, while CachedWebservice adds the caching functionality on top.
 The CachedWebservice class can be looked at as a simple wrapper around Webserbice
 
 
 -parameters:
    -webservice: An Instance of the Webservice Class
 */
final class CachedWebService<R : Resource> {
    let webservice: Roost<R>
    let cache : Cache<R>
    
    
    
    init(_ webservice: Roost<R>, cache: Cache<R> = Cache()) {
        self.webservice = webservice
        self.cache = cache
    }
    
    
    /// load data from resource
    func load(_ resource: R, update: @escaping (Result<R.T>) -> ()) {
        // return cached data if any
        if let result = cache.load(resource) {
            print("Cache Hit")
            update(.success(result))
        }
        
        // In any case hit the end point
        webservice.load(resource, completion: update)
    }
}

