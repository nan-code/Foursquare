//
//  Dialog.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import PopupDialog

class Dialog {
    static func displayMessage(with title: String, message: String, on viewController: UIViewController) {
        let popup = PopupDialog(title: title, message: message)
        let button = DefaultButton(title: "Okay", dismissOnTap: true, action: nil)
        popup.addButton(button)
        viewController.present(popup, animated: true, completion: nil)
    }
    
    static func displayError(with message: String, on viewController: UIViewController) {
        let popup = PopupDialog(title: "Error", message: message)
        let button = DefaultButton(title: "Okay", dismissOnTap: true, action: nil)
        popup.addButton(button)
        viewController.present(popup, animated: true, completion: nil)
    }
}
