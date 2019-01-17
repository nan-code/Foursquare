//
//  VenueRequest.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/13/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import Alamofire

class VenueRequest: RequestBase {
    init(searchText: String, location: UserLocation?, offset: Int) {
        super.init(url: "https://api.foursquare.com/v2/venues/explore")
        
        parameters = [
            "client_id": FoursquareAccount.clientID,
            "client_secret": FoursquareAccount.clientSecret,
            "query": searchText,
            "offset": offset, 
            "v": "20180113",
            "limit": 20
        ]
        
        if let location = location {
            parameters?["ll"] = "\(location.latitude),\(location.longitude)"
        } else {
            parameters?["intent"] = "global"
        }
    }
}

class VenueRequestSearch: RequestBase {
    init(searchText: String, location: UserLocation?, offset: Int) {
        super.init(url: "https://api.foursquare.com/v2/venues/search")
        
        parameters = [
            "client_id": FoursquareAccount.clientID,
            "client_secret": FoursquareAccount.clientSecret,
            "query": searchText,
            "offset": offset,
            "v": "20180113",
            "limit": 20
        ]
        
        if let location = location {
            parameters?["ll"] = "\(location.latitude),\(location.longitude)"
        } else {
            parameters?["intent"] = "global"
        }
    }
}
