//
//  Networkrequest.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error, CustomStringConvertible {
    case invalidURL(String)
    
    var description: String {
        switch self {
        case .invalidURL(let url): return "The url '\(url)' was invalid"
        }
    }
}

struct NetworkRequest {
    //MARK: - HTTP Methods
    enum Method: String {
        case GET        = "GET"
        case PUT        = "PUT"
        case PATCH      = "PATCH"
        case POST       = "POST"
        case DELETE     = "DELETE"
    }
    
    //MARK: - Public Properties
    let method: NetworkRequest.Method
    let endpoint: String
    let parameters:[String:String]?
    
    //MARK: - Public Functions
    func buildURLRequest() throws -> URLRequest {
        
        var components = URLComponents(string: endpoint)
        
        // Convert parameters into queryItems
        if let parameters = parameters {
            components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        }
        
        guard let url = components?.url else {
            throw NetworkRequestError.invalidURL(self.endpoint)
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        return request as URLRequest
    }
}

