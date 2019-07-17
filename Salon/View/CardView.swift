//
//  CardView.swift
//  Godeldriver
//
//  Created by Rahul Tiwari on 01/09/17.
//  Copyright © 2017 Rahul Tiwari. All rights reserved.
//
import UIKit

@IBDesignable
class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: Int = 3
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowRadius = 2.0
    @IBInspectable var shadowColor: UIColor? = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
    @IBInspectable var shadowOpacity: Float = 1.0
    @IBInspectable var borderWidth: Float = 1.0
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
        layer.shadowRadius = CGFloat(shadowRadius)
    }
//    @IBInspectable var cornerRadius: CGFloat = 2
//
//    @IBInspectable var shadowOffsetWidth: Int = 1
//    @IBInspectable var shadowOffsetHeight: Int = 2
//    @IBInspectable var shadowColor: UIColor? = UIColor.white
//    @IBInspectable var shadowOpacity: Float = 4
//
//    override func layoutSubviews() {
//        layer.cornerRadius = cornerRadius
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.cgPath
//    }

}
