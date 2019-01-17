//
//  VenueContactCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

class VenueContactCell: UITableViewCell {
    
    static let identifier = "VenueContactCellIdentifier"
    
    @IBOutlet var stackView: UIStackView!
    
    private enum ContactType {
        case phone
        case url
    }
    
    func configure(contact: VenueContact?) {
        guard let contact = contact else { return }
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // clear subviews before re-adding them
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        if let formattedPhone = contact.formattedPhone ?? contact.phone {
            addContactView(title: "Phone", detail: formattedPhone)
        }
        
        if let facebook = contact.facebook {
            addContactView(title: "Facebook", detail: "www.facebook.com/\(facebook)")
        }
        if let twitter = contact.twitter {
            addContactView(title: "Twitter", detail: "www.twitter.com/\(twitter)")
        }
        if let instagram = contact.instagram {
            addContactView(title: "Instagram", detail: "www.instagram.com/\(instagram)")
        }
    }
    
    private func addContactView(title: String?, detail: String?) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true

        let titleLabel: UILabel = UILabel()
        titleLabel.text = title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.625
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let detailLabel: UILabel = UILabel()
        detailLabel.text = detail
        detailLabel.textAlignment = .right
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.minimumScaleFactor = 0.625
        detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(stack)
    }
}
