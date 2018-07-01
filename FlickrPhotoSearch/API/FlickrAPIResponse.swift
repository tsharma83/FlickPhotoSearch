//
//  FlickrAPIResponse.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

struct FlickrAPIResponse: Decodable {
    let photo: [FlickrPhoto]
    let page: Int
    let pages: Int
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    enum PhotosKeys: String, CodingKey {
        case page
        case pages
        case photo
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let photos = try values.nestedContainer(keyedBy:PhotosKeys.self, forKey: .photos)
        page = try photos.decode(Int.self, forKey: .page)
        pages = try photos.decode(Int.self, forKey: .pages)
        photo = try photos.decode([FlickrPhoto].self, forKey: .photo)
    }
}

