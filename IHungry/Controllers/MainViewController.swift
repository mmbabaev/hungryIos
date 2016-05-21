//
//  MainViewController.swift
//  IHungry
//
//  Created by Михаил on 22.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let api = HungryApi.sharedInstance
    
    @IBAction func iHungryClicked(sender: UIButton) {
        func successBlock() {
            showAlert("Success", message: "")
        }
        
        func failedBlock(message: String) {
            showErrorAlert(message)
        }
        
        api.iHungry(successBlock, failedBlock: failedBlock, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
