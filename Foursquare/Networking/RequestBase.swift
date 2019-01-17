//
//  Request.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import Alamofire

class RequestBase {
    var url: URLConvertible
    var httpMethod: HTTPMethod = .get
    var parameters: Parameters?
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders?
    
    public init(url urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("Do not pass invalid URL strings")
        }
        self.url = url
    }
}
