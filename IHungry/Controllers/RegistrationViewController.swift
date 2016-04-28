//
//  RegistrationViewController.swift
//  IHungry
//
//  Created by Михаил on 21.03.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit
import SwiftForms

class RegistrationViewController: FormViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    struct Static {
        static let name = "name"
        static let password = "pass"
        static let confirmPassword = "confirmPassword"
        static let surname = "surname"
        static let sex = "gender"
        static let dorm = "dorm_id"
        static let flat = "flat"
        static let phone = "phone"
        static let faculty = "fac_id"
    }
    
    var nameField: FormRowDescriptor!
    var surnameField: FormRowDescriptor!
    var passwordField: FormRowDescriptor!
    var confirmPasswordField: FormRowDescriptor!
    var sexSegment: FormRowDescriptor!
    var dormPicker: FormRowDescriptor!
    var flatField: FormRowDescriptor!
    var phoneField: FormRowDescriptor!
    var facultyPicker: FormRowDescriptor!

    var mail: String! = "mmbabaev@gmail.com"
    var code: String! = ""
    let imagePicker = UIImagePickerController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .Plain, target: self, action: #selector(RegistrationViewController.cancel(_:)))
        
        let nextButton = UIBarButtonItem(title: "Готово", style: .Plain, target: self, action: #selector(RegistrationViewController.nextClicked(_:)))
        self.navigationItem.rightBarButtonItem = nextButton
        
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(RegistrationViewController.userImageClicked(_:)))
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func userImageClicked(sender: UIImageView) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func nextClicked(sender: UIBarButtonItem) {
        
        let api = HungryApi.sharedInstance
        
        for key in form.formValues().allKeys {
            if let _ = form.formValues().objectForKey(key) as? NSNull {
                showErrorAlert("Все поля обязательны для заполнения!")
                return
            }
        }
        
        if form.formValues().valueForKey("pass") as! String !=
            form.formValues().valueForKey("confirmPassword") as! String {
            showErrorAlert("Введенные пароли не совпадают")
            return
        }
        
        var values = form.formValues() as! [String : String]
        values["mail"] = mail
        values["vk"] = ""
        values["code"] = code
        
        api.registration(mail, withFormValues: (values)) {
            
            message in
            if message == "success" {
                let alertController = UIAlertController(title: "Регистрация", message: "Пользователь с адресом \(self.mail) успешно зарегистрирован", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default) {
                    alert in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                self.showErrorAlert(message)
            }
        }
    }
    
    private func loadForms() {
        form = FormDescriptor()
        form.title = "Профиль"
        
        // create name-surname
        
        let nameSection = FormSectionDescriptor()
        nameSection.headerTitle = ""
        
        var row = FormRowDescriptor(tag: Static.name, rowType: .Name, title: "Имя")
        
        nameSection.addRow(row)
        row = FormRowDescriptor(tag: Static.surname, rowType: .Name, title: "Фамилия")
        nameSection.addRow(row)
        form.addSection(nameSection)
        
        let passSection = FormSectionDescriptor()
        passSection.headerTitle = "Пароль"
        
        row = FormRowDescriptor(tag: Static.password, rowType: .Password, title: "Пароль")
        passSection.addRow(row)
        
        row = FormRowDescriptor(tag: Static.confirmPassword, rowType: .Password, title: "Подтвердите пароль")
        passSection.addRow(row)
        
        form.addSection(passSection)
        
        // create sex segment
        let sexSection = FormSectionDescriptor()
        sexSection.headerTitle = "Пол"
        
        row = FormRowDescriptor(tag: Static.sex, rowType: .SegmentedControl, title: "")
        
        row.configuration[FormRowDescriptor.Configuration.Options] = ["М", "Ж"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case "М":
                return "Мужской"
            case "Ж":
                return "Женский"
            default:
                return nil
            }
            } as TitleFormatterClosure
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["titleLabel.font" : UIFont.boldSystemFontOfSize(30.0), "segmentedControl.tintColor" : UIColor.blueColor()]
        sexSection.addRow(row)
        
        form.addSection(sexSection)
        
        // create dorm
        let dormSection = FormSectionDescriptor()
        dormSection.headerTitle = "Проживание"
        row = FormRowDescriptor(tag: Static.dorm, rowType: .Picker, title: "Общежитие")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["d 1", "d 2", "d 3"]
        row.value = "d 1"
        dormSection.addRow(row)
        
        row = FormRowDescriptor(tag: Static.flat, rowType: .Text, title: "Квартира")
        dormSection.addRow(row)
        
        form.addSection(dormSection)
        
        // create phone-faculty
        let lastSection = FormSectionDescriptor()
        lastSection.headerTitle = "Другое"
        lastSection.addRow(FormRowDescriptor(tag: Static.phone, rowType: .Phone, title: "Телефон"))
        
        row = FormRowDescriptor(tag: Static.faculty, rowType: .Picker, title: "Факультет")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["f 1", "f 2", "f3"]
        row.value = "f 1"
        lastSection.addRow(row)
        
        form.addSection(lastSection)
        self.form = form
    }
    
    func cancel(sender: UIBarButtonItem) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
