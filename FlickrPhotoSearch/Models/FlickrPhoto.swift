//
//  FlickrPhoto.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

struct FlickrPhoto: Decodable {
    private(set) var fileURL: String
    
    private let farm: Int
    private let server: String
    private let id: String
    private let secret: String
    
    enum CodingKeys: String, CodingKey {
        case farm
        case server
        case id
        case secret
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        farm = try values.decode(Int.self, forKey: .farm)
        server = try values.decode(String.self, forKey: .server)
        id = try values.decode(String.self, forKey: .id)
        secret = try values.decode(String.self, forKey: .secret)
        
        fileURL = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

