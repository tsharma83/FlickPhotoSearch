//
//  Photodownloader.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation
import UIKit

enum PhotoDownloaderError: Error, CustomStringConvertible {
    case invalidResponse
    var description: String {
        switch self {
        case .invalidResponse: return "Received an invalid photo"
        }
    }
}

class PhotoDownloader {
    //MARK: - Private
    fileprivate var cache = [String: UIImage]()
    fileprivate let network: Network
    
    //MARK: - Lifecycle
    required init(network: Network) {
        self.network = network
    }
    
    //MARK: - Public
    func download(url: String, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) -> NetworkCancelable? {
        
        // Return the image if it is there in the cache
        if let existing = self.cache[url] {
            success(existing)
            return nil
        }
        
        let request = NetworkRequest(method: .GET, endpoint: url, parameters: nil)
        return self.network.makeRequest(
            request,
            success: { [weak self] (data: Data) in
                guard let image = UIImage(data: data) else {
                    failure(PhotoDownloaderError.invalidResponse)
                    return
                }
                
                // Save the image into an in-memory cache and fire success callback
                self?.cache[url] = image
                success(image)
            },
            failure: failure)
    }
}

