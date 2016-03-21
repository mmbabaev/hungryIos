//
//  CheckCodeViewController.swift
//  IHungry
//
//  Created by Михаил on 17.03.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class CheckCodeViewController: UIViewController {

    @IBOutlet weak var passField: UITextField!
    
    let api = HungryApi.sharedInstance
    var mail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Далее", style: .Plain, target: self, action: "nextButtonClicked:")
        self.navigationItem.rightBarButtonItem = nextButton
    
        // Do any additional setup after loading the view.
    }

    func nextButtonClicked(sender: UIBarButtonItem) {
        if let code = passField.text {
            if let numbers = Int(code) {
                if numbers > 9999 || numbers < 1000 {
                    showErrorAlert("Код должен содержать 4 цифры!")
                    return
                }
            }
            else {
                showErrorAlert("Код должен содержать 4 цифры!")
                return
            }
        }
        
        api.checkCode(mail, code: passField.text!) {
            message in
            if message == "success" {
                self.performSegueWithIdentifier("showRegistration", sender: self.mail)
            }
            else {
                self.showErrorAlert(message)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case "showRegistration":
            let registrationVC = segue.destinationViewController as! RegistrationViewController
            print(mail)
            registrationVC.mail = mail
        default: break
            
        }
    }
}
















