//
//  SalonDetailTableViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 2018/9/7.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit

class SalonDetailTableViewController: BaseViewController {
   
    var ControllerName = String()
    var info: DealModel!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var addressCell: UILabel!
    @IBOutlet weak var BookPayBtn: UIButton!
    @IBOutlet weak var Salon: UILabel!
    @IBOutlet weak var Services: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var UserName: UILabel!
    
    var InstagramUsernam:String?
    @IBAction func newAppointmentButton(_ sender: UIBarButtonItem) {
        self.newAppointment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ControllerName == "Professionals"{
            self.BookPayBtn.setTitle("Request Appointment", for: .normal)
        
        }
        if info != nil{
        nameCell.text = "Stylist Name - " + info.Name
            priceCell.text = "Price - " + "Regular Price " + info.PromoPrice + " and Discount " + "\(Int(info.TotalDiscount) ?? 0)" + " %"
        timeCell.text =  "\(info.TimeDate.prefix(8))"
        addressCell.text = "Distance From You - " + "2.5 Miles"
        Services.text =  "Services - " + info.Services.joined(separator: ",")
        Date.text = "\(info.TimeDate.suffix(8))"
        UserName.text = info.Name
        }
    }
    
    @IBAction func InstagramButtonAction(_ sender: Any) {

         let instagramHooks = "instagram://user?username=zuck"
         let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/zuck")! as URL)
        }
    }
    @IBAction func BookPayAction(_ sender: UIButton) {
        if sender.title(for: .normal) == "Request Appointment"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleAppontmentController") as! ScheduleAppontmentController
            vc.ControllerName = "View Deals"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
}
