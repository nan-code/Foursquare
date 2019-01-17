//
//  VenueCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class VenueCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var cityStateLabel: UILabel!
    
    static let identifier = "VenueCellIdentifier"
    
    func configure(with viewModel: VenueCellViewModel) {
        //configure cell here
        imageView.pin_setImage(from: viewModel.venueImageURL)
        nameLabel.text = viewModel.venueName
        distanceLabel.text = viewModel.venueDistance
        cityStateLabel.text = viewModel.venueLocation
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        imageView.pin_cancelImageDownload()
        imageView.image = nil
        nameLabel.text = nil
        distanceLabel.text = nil
        cityStateLabel.text = nil
        super.prepareForReuse()
    }
}
