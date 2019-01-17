//
//  VenueDetailRequest.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import Alamofire

class VenueDetailRequest: RequestBase {
    init(venueId: String) {
        super.init(url: "https://api.foursquare.com/v2/venues/\(venueId)")
        
        parameters = [
            "client_id": FoursquareAccount.clientID,
            "client_secret": FoursquareAccount.clientSecret,
            "v": "20180113"
        ]
    }
}
