//
//  User.swift
//  IHungry
//
//  Created by Михаил on 18.02.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import Foundation

class User {
    var id: String
    var password: String
    
    init(id: String, password: String) {
        self.id = id
        self.password = password
    }
}