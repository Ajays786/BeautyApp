//
//  MessageTableViewCell.swift
//  Salon
//
//  Created by 刘恒宇 on 10/12/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var PictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
