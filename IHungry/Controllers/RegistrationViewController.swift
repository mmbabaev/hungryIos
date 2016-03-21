//
//  RegistrationViewController.swift
//  IHungry
//
//  Created by Михаил on 19.03.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftForms

class RegistrationViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dormField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var facultyField: UITextField!

    var mail: String!
    var dorms = ["dorm 1", "dorm 2"]
    var faculties = ["f 1", "f 2", "f 3"]
    
     let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Готово", style: .Plain, target: self, action: "nextClicked:")
        self.navigationItem.rightBarButtonItem = nextButton
        
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("userImageClicked:"))
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func userImageClicked(sender: UIImageView) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func nextClicked(sender: UIBarButtonItem) {
        let api = HungryApi.sharedInstance
        
        if passField.text == "" || nameField.text == "" || surnameField.text == "" || dormField.text == "" || roomField.text == "" {
            showErrorAlert("Заполните все обязательные поля!")
            return
        }
        
        if passField.text != confirmPassField.text {
            showErrorAlert("Введенные пароли не совпадают")
            return
        }
        
        api.registration(mail, surname: surnameField.text!, name: nameField.text!, password: passField.text!, sex: sexSegment.selectedValue!, phone: phoneField.text!, vk: "", dormId: dormField.text!, flat: roomField.text!, facultyId: facultyField.text!) {
            
            message in
            if message == "success" {
                self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                self.showErrorAlert(message)
            }
        }
    }
    
    @IBAction func facultyClicked(sender: UITextField) {
        self.view.endEditing(true)
        let index = faculties.indexOf(sender.text!)
        var initialIndex = 0
        if index != nil {
            initialIndex = index!
        }
        ActionSheetStringPicker.showPickerWithTitle("Выберите факультет", rows: faculties, initialSelection: initialIndex, doneBlock: {
            picker, selectedIndex, selectedValue in
            self.facultyField.text = selectedValue as? String
            return
            }, cancelBlock: nil, origin: sender)

    }
    
    @IBAction func dormClicked(sender: UITextField) {
        self.view.endEditing(true)
        let index = dorms.indexOf(sender.text!)
        var initialIndex = 0
        if index != nil {
            initialIndex = index!
        }

        ActionSheetStringPicker.showPickerWithTitle("Выберите общежитие", rows: dorms, initialSelection: initialIndex, doneBlock: {
                picker, selectedIndex, selectedValue in
                self.dormField.text = selectedValue as? String
                return
        }, cancelBlock: nil, origin: sender)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.contentMode = .ScaleAspectFit
            userImageView.image = pickedImage
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}











