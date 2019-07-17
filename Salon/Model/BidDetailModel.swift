//
//  BidDetailModel.swift
//  Salon
//
//  Created by 刘恒宇 on 9/28/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class BidDetailModel {
    var uid: String
    var price: String
    
    init(data: [String: Any]) {
        guard let uid = data["uid"] as? String,
            let price = data["price"] as? String else {
                self.uid = "null uid"
                self.price = "null price"
                return
        }
        self.price = price
        self.uid = uid
    }
}
