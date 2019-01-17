//
//  VenueCellViewModel.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

struct VenueCellViewModel {
    let venueName: String
    let venueDistance: String
    let venueLocation: String
    let venueImageURL: URL?
}

extension VenueCellViewModel {
    static func makeViewModel(venue: Venue) -> VenueCellViewModel {
        let category = venue.categories.first(where: { $0.primary })
        var venueImagelURL: URL? = nil
        if let category = category {
            venueImagelURL = URL(string: "\(category.icon.prefix)88\(category.icon.suffix)")
        }
        let distance = venue.location.distance == -1 ? "" : "\(venue.location.distance)m"
        var location = venue.location.city ?? ""
        if let state = venue.location.state, !state.isEmpty {
            location += ", \(state)"
        }
        
        return VenueCellViewModel(
            venueName: venue.name,
            venueDistance: distance,
            venueLocation: location,
            venueImageURL: venueImagelURL
        )
    }
}
