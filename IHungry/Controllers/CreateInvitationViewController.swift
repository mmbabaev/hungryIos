//
//  CreateInvitation.swift
//  IHungry
//
//  Created by Михаил on 07.05.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class CreateInvitationViewController: UIViewController {
    let timeFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    @IBAction func cancelButtonClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(sender: UIBarButtonItem) {
        let dish = dishTextField.text ?? ""
        let dishAbout = dishAboutTextView.text
        //let time = String(Int(timePicker.date.timeIntervalSince1970))
        let time = timePicker.date.toDateTimeString()
        let invitation = Invitation(dish: dish, dishAbout: dishAbout, time: time)
        
        HungryApi.sharedInstance.makeInvite(invitation, successBlock: {
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failedBlock: showErrorAlert, sender: self)
    }
    
    @IBOutlet weak var dishTextField: UITextField!
    @IBOutlet weak var dishAboutTextView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
}
