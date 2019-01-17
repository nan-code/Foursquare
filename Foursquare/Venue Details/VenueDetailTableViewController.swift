//
//  VenueDetailTableViewController.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

protocol VenueDetailTableViewInput: class {
    func didUpdate(withDetails: VenueDetails)
}

class VenueDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let identifier = "VenueDetailTableViewController"
    
    @IBOutlet var tableView: UITableView!
    
    var venueDetails: VenueDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "VenueTitleDetailCell", bundle: nil), forCellReuseIdentifier: VenueTitleDetailCell.identifier)
        tableView.register(UINib(nibName: "VenueHoursCell", bundle: nil), forCellReuseIdentifier: VenueHoursCell.identifier)
        tableView.register(UINib(nibName: "VenueLocationCell", bundle: nil), forCellReuseIdentifier: VenueLocationCell.identifier)
        tableView.register(UINib(nibName: "VenueRatingCell", bundle: nil), forCellReuseIdentifier: VenueRatingCell.identifier)
        tableView.register(UINib(nibName: "VenueContactCell", bundle: nil), forCellReuseIdentifier: VenueContactCell.identifier)
    }
    
    enum CellType: Int {
        case name
        case venueDescription
        case location
        case rating
        case contact
        case url
        case hours
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = venueDetails else { return 0 }
        return 7
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let venueDetails = venueDetails, let type = CellType(rawValue: indexPath.row) else { return UITableViewCell() }
        
        var cell: UITableViewCell?
        switch type {
        case .name:
            let standardCell = tableView.dequeueReusableCell(withIdentifier: VenueTitleDetailCell.identifier, for: indexPath) as? VenueTitleDetailCell
            standardCell?.configure(title: "Name", detail: venueDetails.name)
            cell = standardCell
        case.venueDescription:
            let standardCell = tableView.dequeueReusableCell(withIdentifier: VenueTitleDetailCell.identifier, for: indexPath) as? VenueTitleDetailCell
            standardCell?.configure(title: "Description", detail: venueDetails.venueDescription)
            cell = standardCell
        case .url:
            let standardCell = tableView.dequeueReusableCell(withIdentifier: VenueTitleDetailCell.identifier, for: indexPath) as? VenueTitleDetailCell
            standardCell?.configure(title: "URL", detail: venueDetails.url)
            cell = standardCell
        case .location:
            let locationCell = tableView.dequeueReusableCell(withIdentifier: VenueLocationCell.identifier, for: indexPath) as? VenueLocationCell
            locationCell?.configure(location: venueDetails.location)
            cell = locationCell
        case .rating:
            let ratingCell = tableView.dequeueReusableCell(withIdentifier: VenueRatingCell.identifier, for: indexPath) as? VenueRatingCell
            ratingCell?.configure(rating: venueDetails.rating)
            cell = ratingCell
        case .contact:
            let contactCell = tableView.dequeueReusableCell(withIdentifier: VenueContactCell.identifier, for: indexPath) as? VenueContactCell
            contactCell?.configure(contact: venueDetails.contact)
            cell = contactCell
        case .hours:
            let hoursCell = tableView.dequeueReusableCell(withIdentifier: VenueHoursCell.identifier, for: indexPath) as? VenueHoursCell
            hoursCell?.configure(hours: venueDetails.hours)
            cell = hoursCell
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let detail = venueDetails, let type = CellType(rawValue: indexPath.row) else { return 0 }
        
        switch type {
        case .name:
            if let name = detail.name, !name.isEmpty {
                return 60
            }
        case .venueDescription:
            if let desc = detail.venueDescription, !desc.isEmpty {
                return 60
            }
        case .url:
            if let url = detail.url, !url.isEmpty {
                return 60
            }
        case .location:
            if let addresses = detail.location?.formattedAddress, !addresses.isEmpty {
                return UITableView.automaticDimension
            }
        case .rating:
            if detail.rating >= 0 {
                return 60
            }
        case .contact:
            if let numberOfContacts = detail.contact?.numberOfContacts, numberOfContacts > 0 {
                return UITableView.automaticDimension
            }
        case .hours:
            if let timeframes = detail.hours?.timeframes, !timeframes.isEmpty {
                return UITableView.automaticDimension
            }
        }
        
        return 0
    }
    
}

extension VenueDetailTableViewController: VenueDetailTableViewInput {
    func didUpdate(withDetails details: VenueDetails) {
        venueDetails = details
        tableView.reloadData()
    }
}

