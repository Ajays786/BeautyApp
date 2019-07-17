//
//  BidModel.swift
//  Salon
//
//  Created by 刘恒宇 on 9/28/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class BidModel {
    var style: String
    var uid: String
    var status: Bool
    var chosen: String?
    
    init(data: [String: Any]) {
        guard let style = data["style"] as? String,
            let uid = data["userID"] as? String else {
                self.style = "NULL"
                self.uid = "NULL"
                self.status = false
                return
        }
        self.style = style
        self.uid = uid
        self.status = data["status"] as? Bool ?? false
        if status {
            chosen = data["chosen"] as? String
        }
    }
}

