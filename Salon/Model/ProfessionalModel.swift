//
//  ProfessionalModel.swift
//  Salon
//
//  Created by Rahul Tiwari on 7/11/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import Foundation

class ProModel {
    var name: String?
    var token: String?
    var icon: String?
    var PType = ""
    var userID = ""
    init(data: [String: Any]) {
        if let name = data["name"] as? String{
            self.name = name
        }
        else{
            self.name = "error"
        }
        if let icon = data["icon"] as? String{
            self.icon = icon
        }
        else{
            self.icon = "error"
        }
        if let token = data["token"] as? String{
            self.token = token
        }
        else{
            self.token = "error"
        }
        if let PType = data["Type"] as? String{
            self.PType = PType
        }
        else{
            self.PType = "error"
        }
        if let userID = data["userID"] as? String{
            self.userID = userID
        }
        else{
            self.userID = "error"
        }
    }
}
