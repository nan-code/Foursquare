//
//  VenueRatingCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class VenueRatingCell: UITableViewCell {
    
    static let identifier = "VenueRatingCellIdentifier"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var starContainerView: UIView!
    @IBOutlet var starView: CosmosView!
    
    func configure(rating: Double) {
        starView.settings.fillMode = StarFillMode.precise
        starView.settings.updateOnTouch = false
        starView.settings.starSize = Double(starContainerView.frame.height / 3)
        starView.rating = rating / 2
    }
}
