//
//  CustomButtonBlue.swift
//  GodleDriver
//
//  Created by Rahul Tiwari on 25/04/18.
//  Copyright © 2018 Rahul Tiwari. All rights reserved.
//

import UIKit

class CustomButtonBlue: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
//            shadowLayer.fillColor =  UIColor(red: 9/255, green: 113/255, blue: 206/255, alpha: 1.0).cgColor
//
//            shadowLayer.shadowColor =  UIColor(red: 9/255, green: 113/255, blue: 206/255, alpha: 1.0).cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//            shadowLayer.shadowOpacity = 0.8
//            shadowLayer.shadowRadius = 10
//
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
}

