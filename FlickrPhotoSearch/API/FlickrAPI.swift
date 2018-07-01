//
//  FlickrAPI.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

enum FlickrAPIError: Error, CustomStringConvertible {
    case invalidResponse
    case notFound
    
    var description: String {
        switch self {
        case .invalidResponse: return "Received an invalid response"
        case .notFound: return "Requested item was not found"
        }
    }
}


/// Flickr specific web APIs
class FlickrAPI {
    
    //MARK: - Private
    fileprivate let network: Network
    private let apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    private var endPoint:String {
        return "https://api.flickr.com/services/rest/"
    }
    
    //MARK: - Lifecycle
    init(network: Network) {
        self.network = network
    }
    
    //MARK: - Public
    func fetchPhotos(
        matching query: String, page: Int,
        onCompletion: @escaping (FlickrSearchResult) -> Void) {
        
        // Create a network request from endpoint and query/page
        let parameters = ["method":"flickr.photos.search",
                          "api_key":apiKey,
                          "format":"json",
                          "nojsoncallback":"1",
                          "safe_search":"1",
                          "per_page": "21",
                          "text":query,
                          "page": String(page)]
        
        let request = NetworkRequest(method: .GET,
                                     endpoint: endPoint,
                                     parameters:parameters
        )
        
        func fireError(_ error: Error?) {
            onCompletion(FlickrSearchResult(searchText: query,
                                            photos:nil,
                                            error: error,
                                            currentPage: page,
                                            pageCount: 0))
        }
        
        func fireSuccess(_ data: Data) {
            do {
                let result = try JSONDecoder().decode(FlickrAPIResponse.self, from: data)
                onCompletion(FlickrSearchResult(searchText: query,
                                                photos:result.photo,
                                                error: nil,
                                                currentPage: result.page,
                                                pageCount: result.pages))
            } catch  {
                fireError(error)
            }
        }
        
        _ = self.network.makeRequest(
            request,
            success: { (data: Data) in
                fireSuccess(data)
        },
            failure: { (error: Error?) in
                fireError(error)
        })
    }
}

