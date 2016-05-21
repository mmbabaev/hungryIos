//
//  HungryApi.swift
//  IHungry
//
//  Created by Михаил on 22.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON


class HungryApi {
    var currentUser: User!
    let appID: String = UIDevice.currentDevice().identifierForVendor!.UUIDString

    //private let host = "http:/hungry.styleru.net:1337/api"
    private let host = "http:/localhost:8000/api"
    
    private let connectionError = "Ошибка соединения"
    
    static let sharedInstance = HungryApi()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        let manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.timeoutIntervalForResource = 5
    }
    
    func registration(mail: String, withFormValues parameters: [String : String], completeBlock: (String -> Void)) {
        
        Alamofire.request(.PUT, "\(host)/registration", parameters: parameters).responseJSON {
            response in switch response.result {
            case .Success(let data):
                let json = JSON(data)
                if "success" == json["status"].string {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(json["accessToken"].string, forKey: "accessToken")
                    defaults.setObject(json["refreshToken"].string, forKey: "refreshToken")
                    completeBlock("success")
                }
                else {
                    completeBlock(json["text"].stringValue)
                }

            case .Failure(_):
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
                if json["status"].stringValue == "error" {
                    let errorMessage = json["text"].stringValue
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
    
    func login(mail: String, password: String,
               successBlock: (() -> Void),
               errorBlock: (String -> Void)) {
        Alamofire.request(.GET, "\(host)/login", parameters: ["mail":mail, "pass":password, "appID":appID]).responseJSON {
            response in
            switch response.result {
                case .Success(let data) :
                    let json = JSON(data)
                    if "error" == json["status"].string {
                        errorBlock(json["text"].stringValue)
                    }
                    else {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let refreshToken = json["refreshToken"].stringValue
                        let token = json["accessToken"].stringValue
                        defaults.setObject(token, forKey: "accessToken")
                        defaults.setObject(refreshToken, forKey: "refreshToken")
                        successBlock()
                    }
            
                case .Failure(_) :
                    errorBlock(self.connectionError)
            }
        }
    }
    
    func makeInvite(invitation: Invitation, successBlock: (() -> ()), failedBlock: (String -> ()), sender: UIViewController) {
        //TODO: здесь обрабатывать meetTime?
        

        
        let params = [
            "token"     : accessToken,
            "dish"      : invitation.dish,
            "dishAbout" : invitation.dishAbout,
            "meetTime"  : invitation.time
        ]
        
        Alamofire.request(.POST, "\(host)/makeInvite", parameters: params).responseJSON {
            response in switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let status = json["status"].stringValue
                
                switch status {
                    case "success":
                        successBlock()
                    case "invalid token":
                        let newSuccessBlock = {
                            self.makeInvite(invitation, successBlock: successBlock, failedBlock: failedBlock, sender: sender)
                        }
                        self.updateToken(sender, successBlock: newSuccessBlock, failedBlock: failedBlock)
                    default:
                        failedBlock(json["text"].stringValue)
                }
                
            case .Failure(_):
                failedBlock(self.connectionError)
            }
        }
    }
    
    func iHungry(successBlock: () -> (), failedBlock: (String) -> (), sender: UIViewController) {
        
        let token = accessToken

        Alamofire.request(.GET, "\(host)/IHungry", parameters: ["token": token]).responseJSON {
            response in switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let status = json["status"].stringValue
                
                switch status {
                case "success":
                    successBlock()
                case "invalid token":
                    let newSuccessBlock = {
                        self.iHungry(successBlock, failedBlock: failedBlock, sender: sender)
                    }
                    self.updateToken(sender, successBlock: newSuccessBlock, failedBlock: failedBlock)
                default:
                    failedBlock(self.connectionError)
                }
                
            case .Failure(_):
                failedBlock(self.connectionError)
            }
        }

    }
    
    private func updateToken(vc: UIViewController, successBlock: (() -> ()), failedBlock: (String -> ())) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let refresh = defaults.valueForKey("refreshToken") as? String
        if refresh == nil {
            vc.showLoginViewController()
            return
        }
        let refreshToken = refresh!
        
        let result = Alamofire.request(.GET, "\(host)/updateToken", parameters: [
            "appID":appID,
            "refreshToken":refreshToken
            ]).responseJSON().result
        
        switch result {
        case .Success(let data):
            let json = JSON(data)
            let status = json["status"]
            if status == "success" {
                let token = json["accessToken"].stringValue
                defaults.setObject(token, forKey: "accessToken")
                successBlock()
            }
            else {
                vc.showLoginViewController()
            }
        case .Failure(_):
            failedBlock(connectionError)
        }
    }
    
    private var accessToken: String {
        return (defaults.valueForKey("accessToken") as? String) ?? ""
    }
    
    private var refreshToken: String {
        return (defaults.valueForKey("refreshToken") as? String) ?? ""
    }
}





















