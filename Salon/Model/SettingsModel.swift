//
//  SettingsModel.swift
//  Salon
//
//  Created by Rahul Tiwari on 4/22/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import Foundation
class Settings{
    var Distance = ""
    var Zip = ""
    var Notification = Bool()
    var Services = [String]()
    
//    override init() {}
//    init(Distance: String, Zip: String, Notification: Bool, Services: [String]) {
//       self.Distance = Distance
//        self.Zip = Zip
//        self.Notification = Notification
//        self.Services = Services
//    }
    init(data: [String: Any]) {
        if let Distance = data["Distance"] as? String{
        self.Distance = Distance
        }
        else {
            self.Distance = "Unknown Distance"
        }
        if let Zip = data["Zip"] as? String{
            self.Zip = Zip
        }
        else{
              self.Zip = "Zip"
        }
        if let Notification = data["Notification"] as? Bool{
            self.Notification = Notification
        }
        else{
            self.Notification = false
        }
        if let Services = data["Services"] as? [String]{
            self.Services = Services
        }
        else{
            self.Services = []
        }
}
}


