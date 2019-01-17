//
//  UITextField+Extensions.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addDoneToolbar() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        
        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }

}
