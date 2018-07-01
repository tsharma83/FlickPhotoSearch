//
//  ApplicationController.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation
import UIKit


/// This class is used creating application level instances. (Application Factory)
class ApplicationController {
    //MARK: - Dependencies
    // User interface starting navigation controller
    fileprivate let navigationController: UINavigationController
    
    //MARK: Shared Instances
    lazy var coordinator = Coordinator(navigationController: self.navigationController,
                                       applicationController: self)
    lazy var network = NetworkProvider(session: URLSession.shared)
    lazy var apiService: FlickrAPI = FlickrAPI(network: network)
    lazy var photoDownloader: PhotoDownloader = PhotoDownloader(network: network)
    
    //MARK: - Lifecycle
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

