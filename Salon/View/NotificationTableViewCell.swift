//
//  NotificationTableViewCell.swift
//  Salon
//
//  Created by Rahul Tiwari on 6/13/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var NotificationDetailslabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var DataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
