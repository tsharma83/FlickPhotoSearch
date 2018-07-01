//
//  Network.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    
    var description: String {
        switch self {
        case .unknown: return "An unknown error occurred"
        case .invalidResponse: return "Received an invalid response"
        }
    }
}

protocol NetworkCancelable {
    func cancel()
}
extension URLSessionDataTask: NetworkCancelable { }

protocol Network {
    func makeRequest(_ request: NetworkRequest, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) -> NetworkCancelable?
}

