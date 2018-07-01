//
//  NetworkProvider.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//


import Foundation

class NetworkProvider: Network {
    
    //MARK: - Private
    let session: URLSession
    
    //MARK: - Lifecycle
    init(session: URLSession = URLSession.shared) {
        self.session = session
        
    }
    
    //MARK: - Public
    func makeRequest(_ request: NetworkRequest,
                     success: @escaping (Data) -> Void,
                     failure: @escaping (Error) -> Void) -> NetworkCancelable? {
        do {
            let request = try request.buildURLRequest()
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async { failure(error ?? NetworkError.unknown) }
                    return
                }
                DispatchQueue.main.async { success(data) }
            })
            task.resume()
            return task
            
        } catch let error {
            failure(error)
            return nil
        }
    }
}

