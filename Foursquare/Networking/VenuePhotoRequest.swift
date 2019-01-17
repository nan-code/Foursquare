//
//  VenuePhotoRequest.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/14/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import Alamofire

class VenuePhotoRequest: RequestBase {
    init(venueId: String) {
        super.init(url: "https://api.foursquare.com/v2/venues/\(venueId)/photos")
        
        parameters = [
            "client_id": FoursquareAccount.clientID,
            "client_secret": FoursquareAccount.clientSecret,
            "limit": 10,
            "v": "20180113"
        ]
    }
}
