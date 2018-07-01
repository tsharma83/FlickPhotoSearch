//
//  FlickrPhotoCell.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    // Unique identifier for this cell, so that when setting the image for this cell we can compare it to it's viewModel's identifier.
    private(set) var uniqueId: String?
    
    func configure(with cellModel:FlickrPhotoCellModel) {
        self.layer.borderWidth = 1.0
        self.uniqueId = cellModel.photo.fileURL
        
        self.photoImageView.image = cellModel.image
        
        cellModel.didUpdate = { [weak self] cellViewModel in
            
            // Set the image only if cell's unique id and cellViewModel's fileURL match.
            // If this cell has been reused by the time image is downloaded
            // then both of these values will be different.
            guard let uniqueId = self?.uniqueId,
                uniqueId == cellViewModel.photo.fileURL
                else { return }
            
            self?.photoImageView.image = cellViewModel.image
        }
        
        cellModel.loadPhotoImage()
    }
}

