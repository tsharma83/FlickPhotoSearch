//
//  Coordinator.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

class Coordinator {
    //MARK: - Private
    fileprivate let navigationController: UINavigationController
    fileprivate let applicationController: ApplicationController
    
    //MARK: - Lifecycle
    init(navigationController: UINavigationController,
         applicationController: ApplicationController) {
        self.applicationController = applicationController
        self.navigationController = navigationController
    }
    
    //MARK: - Public
    func start() {
        self.showPhotosListViewController()
    }
    
    //MARK: - Private
    fileprivate func showPhotosListViewController() {
        let viewModel = FlickrPhotosViewModel(apiService: applicationController.apiService, photoDownloader: applicationController.photoDownloader)
        
        let photosViewController = navigationController.viewControllers.first as! FlickrPhotosViewController
        photosViewController.viewModel = viewModel
    }
}

