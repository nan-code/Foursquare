//
//  UserLocation.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/13/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation

struct UserLocation {
    let latitude: Double
    let longitude: Double    
}

extension UserLocation: Equatable {
    static func == (lhs: UserLocation, rhs: UserLocation) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
