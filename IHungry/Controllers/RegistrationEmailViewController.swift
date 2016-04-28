//
//  RegistrationEmailViewController.swift
//  IHungry
//
//  Created by Михаил on 22.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationEmailViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    var nextButton: UIBarButtonItem!
    
    let api = HungryApi.sharedInstance

    func nextClicked(sender: UIButton) {
        let mail = mailTextField.text!
        
        if mail.isEmpty {
            showErrorAlert("Введите почтовый адрес!")
            return
        }
        
        if !mail.isValidEmail() {
            showErrorAlert("Некорректный e-mail!")
            return
        }
        
        api.sendMail(mail) { json in
            if let jsonOb = json {
                if let error = jsonOb["error"].string {
                    self.showErrorAlert(error)
                }
                else {
                    if jsonOb["status"].string != nil {
                        self.performSegueWithIdentifier("showCodeVC", sender: mail)
                    }
                    else {
                        self.showErrorAlert("Не удалось отправить код")
                    }
                }
            }
            else {
                self.showErrorAlert("Не удалось отправить код")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .Plain, target: self, action: #selector(RegistrationEmailViewController.cancel(_:)))
        
        nextButton = UIBarButtonItem(title: "Далее", style: .Plain, target: self, action: #selector(RegistrationEmailViewController.nextClicked(_:)))
        self.navigationItem.rightBarButtonItem = nextButton
        
        
    }
    
    func cancel(sender: UIBarButtonItem) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showCodeVC":
            let codeVC = segue.destinationViewController as! CheckCodeViewController
            codeVC.mail =  sender as! String
            print(codeVC.mail)
            
        default: break
        }
    }
}
