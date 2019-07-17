//
//  MessageDetailModel.swift
//  Salon
//
//  Created by 刘恒宇 on 10/12/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import Foundation

class MessageDetailModel {
    var message: String?
    var senderID: String?
    init(data: [String: Any]) {
        guard let message = data["message"] as? String else {
            return
        }
        self.message = message
        guard let senderID = data["senderID"] as? String else {
            return
        }
        self.senderID = senderID
    }
}



