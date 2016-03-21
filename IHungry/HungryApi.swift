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
    private let host = "http:/localhost:1337/api"
    
    static let sharedInstance = HungryApi()
    
    func registration(mail: String, surname: String, name: String, password: String, sex: String, phone: String, vk: String, dormId: String, flat: String, facultyId: String, completeBlock: (String -> Void)) {
        let params = [
            "email"     : mail,
            "surname"   : surname,
            "name"      : name,
            "password"  : password,
            "gender"    : sex,
            "phone"     : phone,
            "vk"        : vk,
            "dorm_id"   : dormId,
            "flat"      : flat,
            "facultyId" : facultyId
        ]
        
        Alamofire.request(.PUT, "\(host)/registration", parameters: params).responseJSON {
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
}