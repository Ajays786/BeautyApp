//
//  LoginTextField.swift
//  Salon
//
//  Created by 刘恒宇 on 1/21/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
}
