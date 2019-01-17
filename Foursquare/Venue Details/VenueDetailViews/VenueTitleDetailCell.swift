//
//  VenueTitleDetailCell.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/15/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

class VenueTitleDetailCell: UITableViewCell {
    
    static let identifier = "VenueTitleDetailCellIdentifier"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    func configure(title: String, detail: String?) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
