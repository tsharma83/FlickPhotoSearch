//
//  FlickrPhotosViewModel.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

/// State of content loading
enum State {
    case loading
    case untriggered
    case empty
    case paging([FlickrPhotoCellModel], next: Int)
    case populated([FlickrPhotoCellModel])
    case error(Error)
    
    fileprivate var currentPhotoModels: [FlickrPhotoCellModel] {
        switch self {
        case .paging(let photos, _):
            return photos
        case .populated(let photos):
            return photos
        default:
            return []
        }
    }
}

class FlickrPhotosViewModel {
    // Dependency
    private let apiService: FlickrAPI
    private let photoDownloader: PhotoDownloader
    
    //MARK: - Lifeycle
    init(apiService: FlickrAPI, photoDownloader: PhotoDownloader) {
        self.apiService = apiService
        self.photoDownloader = photoDownloader
    }
    
    private var searchResult:FlickrSearchResult?
    
    // State change callback. It is the state that carry current photos.
    var didChangeState: ((State) -> Void)?
    var state = State.empty {
        didSet {
            didChangeState?(state)
        }
    }
    
    var flickrPhotosCellModels: [FlickrPhotoCellModel] {
        return state.currentPhotoModels
    }
    
    //    fileprivate(set) var photosViewModels = [FlickrPhotosViewModel]()
    
    func didReachedBottom() {
        guard let searchQuery = searchResult?.searchText else {
            return
        }
        loadPhotos(matching: searchQuery)
    }
    
    func loadPhotos(matching query:String) {
        // If the query is different then start from page 1
        // else check if state is .paging then start from next page
        // else return.
        var page = 0
        if searchResult == nil {
            page = 1
            state = .loading
        } else if let currentResult = searchResult,
            currentResult.searchText != query {
            page = 1
            state = .loading
        } else if case .error(_) = state {
            page = 1
            state = .loading
        } else if case .paging(_, let nextPage) = state {
            page = nextPage
        } else {
            return
        }
        
        // get the photos from networking
        apiService.fetchPhotos(matching: query, page: page) { [weak self] result in
            self?.searchResult = result
            self?.update(result: result)
        }
    }
    
    private func update(result: FlickrSearchResult) {
        if let error = result.error {
            state = .error(error)
            return
        }
        
        guard let newPhotos = result.photos,
            !newPhotos.isEmpty else {
                state = .empty
                return
        }
        
        // Append new photos to existing photos.
        var allPhotoModels = state.currentPhotoModels
        let newPhotoModels = newPhotos.map { self.photoCellModelFor($0) }
        allPhotoModels.append(contentsOf: newPhotoModels)
        
        // Change the state based on whether we have more pages or not.
        if result.hasMorePages {
            state = .paging(allPhotoModels, next: result.nextPage)
        } else {
            state = .populated(allPhotoModels)
        }
    }
    
    //MARK: - Helpers
    fileprivate func photoCellModelFor(_ photo: FlickrPhoto)-> FlickrPhotoCellModel {
        let cellModel = FlickrPhotoCellModel(photo: photo,
                                             photoDownloader: self.photoDownloader)
        return cellModel
    }
}

