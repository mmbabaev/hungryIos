//
//  Extensions.swift
//  IHungry
//
//  Created by Михаил on 28.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    var length: Int {
        get {
            return self.characters.count
        }
    }
    func isHseEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@edu.hse.ru"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)

    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}

extension UISegmentedControl {
    var selectedValue: String? {
        return self.titleForSegmentAtIndex(self.selectedSegmentIndex)
    }
}

extension UITextField {
    var isEmpty: Bool {
        get {
            if text == nil || text == "" {
                return true
            }
            else {
                return false
            }
        }
    }
}

extension UIViewController {
    func showLoginViewController() {
        print("show login Vc")
    }
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension NSDate {
    func toDateTimeString() -> String {
        let dateFormat = NSDateFormatter(dateFormat: "yyyy-MM-dd")
        let timeFormat = NSDateFormatter(dateFormat: "HH:mm:ss")
        
        return dateFormat.stringFromDate(self) + " " + timeFormat.stringFromDate(self)
    }
}












