//
//  VenueLocationCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

class VenueLocationCell: UITableViewCell {
    
    static let identifier = "VenueLocationCellIdentifier"
    
    @IBOutlet var stackView: UIStackView!
    
    func configure(location: VenueLocation?) {
        guard let location = location else { return }
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // clear subviews before re-adding them
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }

        for address in location.formattedAddress {
            addLocationView(for: address)
        }
    }
    
    private func addLocationView(for address: String?) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true

        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = address
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.625
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        stack.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(stack)
    }
}
