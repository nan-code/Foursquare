//
//  NetworkService.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import Alamofire

open class NetworkService {
    
    func makeRequest<T: Decodable>(_ request: RequestBase, completion: @escaping (T?) -> Void) {
        AF.request(request.url,
                   method: request.httpMethod,
                   parameters: request.parameters,
                   encoding: request.encoding,
                   headers: request.headers
        )
        .responseDecodable(completionHandler: { (response: DataResponse<T>) in
            guard let value = response.result.value else {
                    completion(nil)
                    return
                }
            completion(value)
        })
    }
}
