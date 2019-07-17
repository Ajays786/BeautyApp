//
//  DealModel.swift
//  Salon
//
//  Created by 刘恒宇 on 2018/9/7.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class DealModel {
    var Services = [String]()
    var Name = ""
    var PromoPrice = ""
    var RegularPrice = ""
    var TotalDiscount = ""
    var uid = ""
    var ServiceOffered = ""
     var TimeDate = ""
    
    //    override init() {}
    //    init(Distance: String, Zip: String, Notification: Bool, Services: [String]) {
    //       self.Distance = Distance
    //        self.Zip = Zip
    //        self.Notification = Notification
    //        self.Services = Services
    //    }
    init(data: [String: Any]) {
        if let Name = data["Name"] as? String{
            self.Name = Name
        }
        else {
            self.Name = "Unknown Name"
        }
        if let PromoPrice = data["PromoPrice"] as? String{
            self.PromoPrice = PromoPrice
        }
        else{
            self.PromoPrice = "error"
        }
        if let RegularPrice = data["RegularPrice"] as? String{
            self.RegularPrice = RegularPrice
        }
        else{
            self.RegularPrice = "error"
        }
        if let Services = data["Services"] as? [String]{
            self.Services = Services
        }
        else{
            self.Services = []
        }
        
        if let TotalDiscount = data["TotalDiscount"] as? String{
            self.TotalDiscount = TotalDiscount
        }
        else {
            self.TotalDiscount = "error "
        }
        if let uid = data["uid"] as? String{
            self.uid = uid
        }
        else {
            self.uid = "error "
        }
        if let ServiceOffered = data["ServiceOffered"] as? String{
            self.ServiceOffered = ServiceOffered
        }
        else {
            self.ServiceOffered = "error "
        }
        if let TimeDate = data["TimeDate"] as? String{
            self.TimeDate = TimeDate
        }
        else {
            self.TimeDate = "error "
        }

    }
}
//Name
//"Sagar Ratna"
//PromoPrice
//"50"
//RegularPrice
//"100"
//ServiceOffered
//"Keen flew flew dmlwdlewd. We flew fleet ewf lenwfnewlf ewf lewnfewf, ew"
//arrow_drop_down
//Services
//0
//"Hair"
//1
//"Spa"
//2
//"Nails"
//TimeDate
//"01:15 01/01/19"
//TotalDiscount
//"50.0"
//(string)
//edit
//delete
//uid
//"4uvnplgqOYMmB1LCPKu3iHD7DPJ3"
