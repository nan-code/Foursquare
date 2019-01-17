//
//  VenueDetailCoordinator.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/14/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class VenueDetailCoordinator: NSObject {
    
    weak var input: VenueDetailViewInput?
    var context: UINavigationController?

    var venuePhotos: [VenuePhoto] = []
    var venueDetails: VenueDetails?
    
    func start(on context: UINavigationController, withVenue venue: Venue) {
        self.context = context
        
        let storyboard = UIStoryboard(name: "VenueDetailView", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: VenueDetailViewController.identifier) as? VenueDetailViewController else {
            fatalError("Double check your storyboards and view controller identifiers")
        }
        
        viewController.output = self
        input = viewController
        context.pushViewController(viewController, animated: true)
        loadDetails(for: venue)
    }
    
    private func loadDetails(for venue: Venue) {
        if let cachedDetails: VenueDetails = RealmService.loadCachedObject(for: venue) {
            input?.didUpdate(withDetails: cachedDetails)
            input?.didUpdate(withPhotos: Array(cachedDetails.photos))
            print(cachedDetails)
            return
        }
        
        let request = VenueDetailRequest(venueId: venue.id)
        NetworkService().makeRequest(request) { [weak self] (response: VenueDetailResponse?) in
            guard let self = self, let details = response?.venueDetails else { return }
            details.venueId = venue.id
            self.input?.didUpdate(withDetails: details)
            self.input?.didUpdate(withPhotos: Array(details.photos))
            RealmService.saveToRealm(object: details)
            self.venueDetails = details
        }
    }
}

extension VenueDetailCoordinator: VenueDetailViewOutput {
    func dismiss() {
        context?.popViewController(animated: true)
    }
}
