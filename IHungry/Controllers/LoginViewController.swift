//
//  LoginViewController.swift
//  IHungry
//
//  Created by Михаил on 22.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        
        if mailField.isEmpty {
            showErrorAlert("Заполните e-mail")
            return
        }
        
        if mailField.text!.isValidEmail() == false {
            showErrorAlert("Некорректный e-mail")
            return
        }
        
        if passwordField.isEmpty {
            showErrorAlert("Заполните пароль")
            return
        }
        
        let api = HungryApi.sharedInstance
        
        func successBlockFunc(id: String) {
            api.currentUser = User(id: id, password: passwordField.text!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        api.login(mailField.text!, password: passwordField.text!, successBlock: successBlockFunc, errorBlock: {er in self.showErrorAlert(er)})
    }
}















