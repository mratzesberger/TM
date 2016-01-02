//
//  functions.swift
//  smap
//
//  Created by Mathias Ratzesberger on 28.01.15.
//  Copyright (c) 2015 Mara-Consulting. All rights reserved.
//

import Foundation
import UIKit

func alert(ViewController: UIViewController, title: String, message: String) {
    
    let button_text = NSLocalizedString("BUTTON_OK", comment: "OK Button")
    
    if let getModernAlert: AnyClass = NSClassFromString("UIAlertController") { // iOS 8
        let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: button_text, style: .Default, handler: nil))
        
        ViewController.presentViewController(myAlert, animated: true, completion: nil)
    } else { // iOS 7
        let alert: UIAlertView = UIAlertView()
        alert.delegate = ViewController
        
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(button_text)
        
        alert.show()
    }
}