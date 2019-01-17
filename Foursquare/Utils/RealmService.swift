//
//  RealmService.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    static func loadCachedObject<T: Object>(for venue: Venue) -> T? {
        do {
            let realm = try Realm()
            let realmDetails = realm.objects(T.self).filter("venueId = '\(venue.id)'")
            guard !realmDetails.isEmpty else {
                return nil
            }
            
            return realmDetails.first
        } catch let error as NSError {
            // would need to implement logging
            print("realm load failed. Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func loadCachedObjects<T: Object>(for venue: Venue) -> [T]? {
        do {
            let realm = try Realm()
            let realmDetails = realm.objects(T.self).filter("venueId = '\(venue.id)'")
            guard !realmDetails.isEmpty else {
                return nil
            }
            
            return Array(realmDetails)
        } catch let error as NSError {
            // would need to implement logging
            print("realm load failed. Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func saveToRealm(object: Object) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            // would need to implement logging
            print("realm save failed. Error: \(error.localizedDescription)")
        }
    }
    
    static func saveToRealm(objects: [Object]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects)
            }
        }
        catch let error as NSError {
            // would need to implement logging
            print("realm save failed. Error: \(error.localizedDescription)")
        }
    }
}
