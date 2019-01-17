//
//  Venue.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import RealmSwift

class VenueResponseExplore: Decodable {
    let venues: [Venue]
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let nestedValues = try values.nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .response)
        let venueData = try nestedValues.decode([VenueData].self, forKey: .groups)
        let venueItems = venueData.flatMap({ $0.venueItems })
        venues = venueItems.map({ $0.venue })
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case response
    }
    
    fileprivate enum AdditionalCodingKeys: String, CodingKey {
        case groups
    }
    
    fileprivate enum GroupCodingKeys: String, CodingKey {
        case items
    }
}

class VenueResponseSearch: Decodable {
    let venues: [Venue]
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let nestedValues = try values.nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .response)
        venues = try nestedValues.decode([Venue].self, forKey: .venues)
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case response
    }
    
    fileprivate enum AdditionalCodingKeys: String, CodingKey {
        case venues
    }
}

// helper functions to decode cleaner
private struct VenueData: Decodable {
    let venueItems: [VenueItem]
    
    fileprivate enum CodingKeys: String, CodingKey {
        case venueItems = "items"
    }
}

private struct VenueItem: Decodable {
    let venue: Venue
}



struct Venue: Decodable {
    let id: String
    let name: String
    let location: VenueLocation
    let categories: [VenueCategory]
}

class VenueLocation: Object, Decodable {
    @objc dynamic var address: String?
    @objc dynamic var crossStreet: String?
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var distance: Int = 0
    @objc dynamic var postalCode: String?
    @objc dynamic var countryCode: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var country: String?
    var formattedAddress: List<String> = List<String>()
    
    fileprivate enum CodingKeys: String, CodingKey {
        case address
        case crossStreet
        case latitude = "lat"
        case longitude = "lng"
        case distance = "distance"
        case postalCode
        case countryCode = "cc"
        case city
        case state
        case country
        case formattedAddress
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try? values.decode(String.self, forKey: .address)
        crossStreet = try? values.decode(String.self, forKey: .crossStreet)
        latitude = (try? values.decode(Double.self, forKey: .latitude)) ?? -1.0
        longitude = (try? values.decode(Double.self, forKey: .longitude)) ?? -1.0
        distance = (try? values.decode(Int.self, forKey: .distance)) ?? -1
        postalCode = try? values.decode(String.self, forKey: .postalCode)
        countryCode = try? values.decode(String.self, forKey: .countryCode)
        city = try? values.decode(String.self, forKey: .city)
        state = try? values.decode(String.self, forKey: .state)
        country = try? values.decode(String.self, forKey: .country)
        
        let addressArray = (try? values.decode([String].self, forKey: .formattedAddress)) ?? []
        formattedAddress = List<String>()
        formattedAddress.append(objectsIn: addressArray)
    }
}

class VenueCategory: Object, Decodable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: CategoryImage
    let primary: Bool
}

struct CategoryImage: Decodable {
    let prefix: String
    let suffix: String
}
