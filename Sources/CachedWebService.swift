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
final class CachedWebService {
    let webservice: Webservice
    let cache : Cache
    
    
    
    init(_ webservice: Webservice, cache: Cache = Cache()) {
        self.webservice = webservice
        self.cache = cache
    }
    
    
    /// load data from resource
    func load<A>(_ resource: JSONResource<A>, update: @escaping (Result<A>) -> ()) {

        // return cached data if any
        if let result = cache.load(resource) {
            print("Cache Hit")
            update(.success(result))
        }
        
        // In any case hit the end point
        webservice.load(resource, completion: update)
    }
    

}

