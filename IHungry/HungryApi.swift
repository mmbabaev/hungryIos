//
//  HungryApi.swift
//  IHungry
//
//  Created by Михаил on 22.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class HungryApi {
    var currentUser: User!
    
    private let host = "http:/localhost:1337/api"
    
    static let sharedInstance = HungryApi()
    
    func registration(mail: String, withFormValues parameters: [String : String], completeBlock: (String -> Void)) {
        print(parameters)
        
        Alamofire.request(.PUT, "\(host)/registration", parameters: parameters).responseJSON {
            response in
            if let jsonData = response.data {
                let json = JSON(data: jsonData)
                if let errorMessage = json["error"].string {
                    completeBlock(errorMessage)
                }
                else {
                    completeBlock("success")
                }
            }
            else {
                completeBlock("Не удалось зарегистрировать пользователя")
            }
        }
    }
    
    func sendMail(receiver: String, completeBlock: (JSON? -> Void)) {
        Alamofire.request(.PUT, "\(host)/sendMail", parameters: ["mail" :receiver]).responseJSON {
            response in
            if let data = response.data {
                completeBlock(JSON(data: data))
            }
            else {
                completeBlock(nil)
            }
        }
    }
    
    func checkCode(mail: String, code: String, completeBlock: (String -> Void)) {
        Alamofire.request(.GET, "\(host)/checkCode", parameters: ["mail":mail, "code":code]).responseJSON {
            response in
            if let jsonData = response.data {
                let json = JSON(data: jsonData)
                if let errorMessage = json["error"].string {
                    completeBlock(errorMessage)
                }
                else {
                    completeBlock("success")
                }
            }
            else {
                completeBlock("Не удалось проверить код")
            }
        }
    }
    
    func login(mail: String, password: String, successBlock: (String -> Void), errorBlock: (String -> Void)) {
        Alamofire.request(.GET, "\(host)/login", parameters: ["mail":mail, "password":password]).responseJSON {
            response in
            if let jsonData = response.data {
                let json = JSON(data: jsonData)
                if let errorMessage = json["error"].string {
                    errorBlock(errorMessage)
                }
                else {
                    successBlock(json["id"].stringValue)
                }
            }
            else {
                errorBlock("Не удалось войти в систему")
            }
        }

    }
}