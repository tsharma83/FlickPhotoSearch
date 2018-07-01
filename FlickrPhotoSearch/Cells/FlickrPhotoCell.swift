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
    private(set) var uniqueId: String?
    
    func configure(with cellModel:FlickrPhotoCellModel) {
        self.layer.borderWidth = 1.0
        self.uniqueId = cellModel.photo.fileURL
        
        self.photoImageView.image = cellModel.image
        
        cellModel.didUpdate = { [weak self] cellViewModel in
            
            // Set the image only if cell's unique id and cellViewModel's fileURL match.
            guard let uniqueId = self?.uniqueId,
                uniqueId == cellViewModel.photo.fileURL
                else { print("Returning"); return }
            
            self?.photoImageView.image = cellViewModel.image
        }
        
        cellModel.loadPhotoImage()
    }
}

