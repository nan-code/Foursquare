//
//  VenueDetails.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import RealmSwift

struct VenueDetailResponse: Decodable {
    let venueDetails: VenueDetails
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let nestedValues = try values.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .response)
        
        venueDetails = try nestedValues.decode(VenueDetails.self, forKey: .venue)
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case response
    }
    
    fileprivate enum NestedCodingKeys: String, CodingKey {
        case venue
    }
}

class VenueDetails: Object, Decodable {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var venueDescription: String?
    @objc dynamic var contact: VenueContact?
    @objc dynamic var location: VenueLocation?
    @objc dynamic var url: String?
    @objc dynamic var hours: VenueHours?
    @objc dynamic var rating: Double = 0.0
    var photos: List<VenuePhoto> = List<VenuePhoto>()
    
    @objc dynamic var venueId: String = ""
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id, name, contact, location, url, hours, rating, photos
        case venueDescription = "description"
    }

    fileprivate enum PhotoCodingKeys: String, CodingKey {
        case groups
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        contact = try? values.decode(VenueContact.self, forKey: .contact)
        location = try? values.decode(VenueLocation.self, forKey: .location)
        url = try? values.decode(String.self, forKey: .url)
        hours = try? values.decode(VenueHours.self, forKey: .hours)
        rating = (try? values.decode(Double.self, forKey: .rating)) ?? -1.0
        
        let photoValues = try values.nestedContainer(keyedBy: PhotoCodingKeys.self, forKey: .photos)
        let photoResponseArray = (try? photoValues.decode([VenuePhotoResponse].self, forKey: .groups)) ?? []
        if let photosArray = photoResponseArray.first(where: { $0.type == "venue" })?.venuePhotos {
            photos = List<VenuePhoto>()
            photos.append(objectsIn: photosArray)
        }
    }
}

class VenueContact: Object, Decodable {
    @objc dynamic var facebook: String?
    @objc dynamic var twitter: String?
    @objc dynamic var instagram: String?
    @objc dynamic var phone: String?
    @objc dynamic var formattedPhone: String?
    
    var numberOfContacts: Int {
        var count = 0
        if let _ = facebook { count += 1 }
        if let _ = twitter { count += 1 }
        if let _ = instagram { count += 1 }
        if let _ = formattedPhone { count += 1 }
        return count
    }
}

class VenueHours: Object, Decodable {
    @objc dynamic var status: String?
    @objc dynamic var isOpen: Bool = false
    var timeframes: List<Timeframe> = List<Timeframe>()

    fileprivate enum CodingKeys: String, CodingKey {
        case status, isOpen, timeframes
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decode(String.self, forKey: .status)
        isOpen = (try? values.decode(Bool.self, forKey: .isOpen)) ?? false
        let timeframeArray = (try? values.decode([Timeframe].self, forKey: .timeframes)) ?? []
        timeframes = List<Timeframe>()
        timeframes.append(objectsIn: timeframeArray)
    }
}

@objc class Timeframe: Object, Decodable {
    @objc dynamic var days: String?
    var open: List<Time> = List<Time>()
    
    fileprivate enum CodingKeys: String, CodingKey {
        case days, open
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        days = try? values.decode(String.self, forKey: .days)
        
        let openArray = (try? values.decode([Time].self, forKey: .open)) ?? []
        open = List<Time>()
        open.append(objectsIn: openArray)
    }
}

class Time: Object, Decodable {
    @objc dynamic var renderedTime: String?
}
