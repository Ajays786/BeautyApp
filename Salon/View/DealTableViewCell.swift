//
//  DealTableViewCell.swift
//  Salon
//
//  Created by 刘恒宇 on 2018/9/7.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Miles: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
