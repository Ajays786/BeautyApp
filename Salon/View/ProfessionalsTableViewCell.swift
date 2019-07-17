//
//  ProfessionalsTableViewCell.swift
//  Salon
//
//  Created by Rahul Tiwari on 5/6/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit
import Cosmos

class ProfessionalsTableViewCell: UITableViewCell {
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var Rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
