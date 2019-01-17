//
//  VenueHoursCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

class VenueHoursCell: UITableViewCell {
    
    static let identifier = "VenueHoursCellIdentifier"
    
    @IBOutlet var stackView: UIStackView!
    
    func configure(hours: VenueHours?) {
        guard let hours = hours else { return }
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // clear subviews before re-adding them
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for timeframe in hours.timeframes {
            addDayHoursView(day: timeframe.days, time: timeframe.open.first)
        }
    }
    
    private func addDayHoursView(day: String?, time: Time?) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true

        let titleLabel: UILabel = UILabel()
        titleLabel.text = day
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.625
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let detailLabel: UILabel = UILabel()
        detailLabel.text = time?.renderedTime
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
