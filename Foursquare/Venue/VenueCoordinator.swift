//
//  VenueCoordinator.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

/// Used in place of a MVVM or VIPER architecture for demo simplicity
class VenueCoordinator: NSObject {
    
    weak var input: VenueViewInput?
    var context: UINavigationController?
    
    var locationManager: CLLocationManager
    var localSearchCompleter: MKLocalSearchCompleter
    var offset: Int = 0
    var venues: [Venue] = []
    var suggestions: [MKLocalSearchCompletion] = []
    
    var currentSearch: String?
    var currentLocationSearch: String?
    var currentLocation: UserLocation?
    
    override init() {
        locationManager = CLLocationManager()
        localSearchCompleter = MKLocalSearchCompleter()
        super.init()
        locationManager.delegate = self
        localSearchCompleter.delegate = self
    }
    
    func start(on context: UINavigationController) {
        self.context = context
        
        let storyboard = UIStoryboard(name: "VenueView", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: VenueViewController.identifier) as? VenueViewController else {
            fatalError("Double check your storyboards and view controller identifiers")
        }
        
        viewController.output = self
        input = viewController
        context.pushViewController(viewController, animated: false)
    }
    
    func loadPage(with searchText: String?, location: UserLocation?) {
        if let location = location {
            let request = VenueRequest(searchText: searchText ?? "", location: location, offset: offset)
            NetworkService().makeRequest(request) { [weak self] (response: VenueResponseExplore?) in
                self?.handleVenueResponse(response?.venues)
            }
        } else {
            if searchText != currentSearch || location != currentLocation {
                let request = VenueRequestSearch(searchText: searchText ?? "", location: location, offset: offset)
                NetworkService().makeRequest(request) { [weak self] (response: VenueResponseSearch?) in
                    self?.handleVenueResponse(response?.venues)
                }
            }
        }
    }
    
    private func handleVenueResponse(_ response: [Venue]?) {
        let venues = response?.sorted(by: { (first, second) -> Bool in
            return first.location.distance < second.location.distance
        }) ?? []
        
        if offset == 0 {
            self.venues = venues
        } else {
            self.venues.append(contentsOf: venues)
        }
        input?.didUpdate(withVenues: venues, offset: offset)
        offset += venues.count
    }
}

//MARK: - VenueViewOutput
extension VenueCoordinator: VenueViewOutput {
    func didCheckLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            guard let viewController = context?.topViewController else { break }
            Dialog.displayMessage(with: "Location Services Disabled", message: "Please enable Location Services in Settings", on: viewController)
        default: break
        }
    }
    
    func search(forVenue searchText: String?) {
        offset = 0
        loadPage(with: searchText, location: currentLocation)
        currentSearch = searchText
    }
    
    func search(forLocation searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            input?.didUpdate(withSuggestions: [])
            
            //still load searches if location is empty and search has a value
            if let search = currentSearch, !search.isEmpty {
                offset = 0
                loadPage(with: search, location: nil)
            }
            
            currentLocation = nil
            currentLocationSearch = ""

            return
        }
        
        guard searchText != currentLocationSearch else {
            input?.didUpdate(withSuggestions: localSearchCompleter.results.map({
                return SearchViewModel(title: $0.title, subtitle: $0.subtitle)
            }))
            return
        }
        
        if localSearchCompleter.isSearching {
            localSearchCompleter.cancel()
        }
        
        localSearchCompleter.queryFragment = searchText
        currentLocationSearch = searchText
    }
    
    func didTapVenue(at index: Int) {
        guard let context = context else { return }
        let detailCoordinator = VenueDetailCoordinator()
        detailCoordinator.start(on: context, withVenue: venues[index])
    }
    
    func didSelectLocation(at index: Int) {
        guard index < suggestions.count else {
            return
        }
        
        guard index >= 0 else {
            didCheckLocation()
            return
        }
        
        let selectedLocation = "\(suggestions[index].title) \(suggestions[index].subtitle)"
        CLGeocoder().geocodeAddressString(selectedLocation) { [weak self] (placemark, _) in
            guard let self = self, let coordinate = placemark?.first?.location?.coordinate else { return }
            self.offset = 0
            self.currentLocation = UserLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.input?.didUpdate(withLocation: selectedLocation)
            self.loadPage(with: self.currentSearch, location: self.currentLocation)
        }
    }
    
    func feedItemWillDisplay(at index: Int) {
        if venues.count - index == 3 {
            loadPage(with: currentSearch, location: currentLocation)
        }
    }
}

extension VenueCoordinator: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            if status == .restricted || status == .denied {
                input?.didUpdate(withLocation: "")
            }
            return
        }
        didCheckLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = UserLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        currentLocationSearch = "📍 Current Location"
        input?.didUpdate(withLocation: currentLocationSearch)
        loadPage(with: currentSearch, location: currentLocation)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let viewController = context?.topViewController else { return }
        Dialog.displayError(with: "Unable to identifiy your location, please manually enter a location", on: viewController)
        print(error.localizedDescription)
    }
}

extension VenueCoordinator: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
        input?.didUpdate(withSuggestions: suggestions.map({
            return SearchViewModel(title: $0.title, subtitle: $0.subtitle)
        }))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        input?.didUpdate(withErrorMessage: error.localizedDescription)
    }
}
