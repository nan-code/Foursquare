//
//  VenueDetailPhotoPageViewController.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/14/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

class VenueDetailPhotoPageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView?
    
    var pageIndex: Int = 0
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageURL = imageURL {
            imageView?.pin_setImage(from: imageURL)
        } else {
            imageView?.image = nil
        }
    }
}
