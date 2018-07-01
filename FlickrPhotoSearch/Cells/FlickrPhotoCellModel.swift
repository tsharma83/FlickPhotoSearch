//
//  FlickrPhotoCellModel.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

class FlickrPhotoCellModel {
    
    //MARK: - Private
    private(set) var photo: FlickrPhoto
    private let photoDownloader: PhotoDownloader
    fileprivate var downloadCancellable: NetworkCancelable?
    private(set) var image: UIImage?
    
    //MARK: - Public
    var didUpdate: ((FlickrPhotoCellModel) -> Void)?
    
    //MARK: - Lifecycle
    init(photo:FlickrPhoto, photoDownloader: PhotoDownloader) {
        self.photo = photo
        self.photoDownloader = photoDownloader
    }
    
    deinit {
        downloadCancellable?.cancel()
    }
    
    func loadPhotoImage() {
        // ignore if we already have an image
        guard self.image == nil else { return }
        
        // ignore if we are already fetching
        guard self.downloadCancellable == nil else { return }
        
        downloadCancellable = photoDownloader.download(url: self.photo.fileURL, success: { [weak self] photo in
            guard let `self` = self else { return }
            
            self.image = photo
            self.didUpdate?(self)
            },failure:{ _ in
                // Handle Failure
        })
    }
}

