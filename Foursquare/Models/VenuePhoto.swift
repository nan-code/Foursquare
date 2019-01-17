//
//  VenuePhoto.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/14/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import RealmSwift

struct VenuePhotoResponse: Decodable {
    let type: String?
    let venuePhotos: [VenuePhoto]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try? values.decode(String.self, forKey: .type)
        venuePhotos = try values.decode([VenuePhoto].self, forKey: .items)
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case type
        case items
    }
}

class VenuePhoto: Object, Decodable {
    @objc dynamic var id: String?
    @objc dynamic var prefix: String?
    @objc dynamic var suffix: String?
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    @objc dynamic var venueId: String = ""

    fileprivate enum CodingKeys: String, CodingKey {
        case id, prefix, suffix, width, height
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        prefix = try? values.decode(String.self, forKey: .prefix)
        suffix = try? values.decode(String.self, forKey: .suffix)
        width = (try? values.decode(Int.self, forKey: .width)) ?? 0
        height = (try? values.decode(Int.self, forKey: .height)) ?? 0
    }
}
