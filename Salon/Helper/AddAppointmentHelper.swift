//
//  AddAppointmentHelper.swift
//  Salon
//
//  Created by 刘恒宇 on 2018/8/31.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    public func newAppointment() {
        let newReservationVC = UINavigationController(rootViewController: NewReservationViewController())
        newReservationVC.title = "New Appointment"
        if #available(iOS 11.0, *) {
            newReservationVC.navigationBar.prefersLargeTitles = true
        }
        self.present(newReservationVC, animated: true, completion: nil)
    }
}
extension UIView {
    
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
}
