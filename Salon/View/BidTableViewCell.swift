//
//  BidTableViewCell.swift
//  Salon
//
//  Created by Rahul Tiwari on 3/11/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit

class BidTableViewCell: UITableViewCell {

    @IBOutlet weak var SalonNameLbl: UILabel!
    
    @IBOutlet weak var PriceLbl: UILabel!
    
    @IBOutlet weak var AdressLbl: UILabel!
    
    @IBOutlet weak var StatusLbl: UILabel!
    
    
    @IBOutlet weak var OwnerNameLbl: UILabel!
    
    @IBOutlet weak var AceeptBtn: CustomButtonBlue!
    
    @IBOutlet weak var DenyBtn: CustomButtonBlue!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        AceeptBtn.layer.cornerRadius = 15.0
        AceeptBtn.layer.shadowColor = UIColor.lightGray.cgColor
        AceeptBtn.layer.shadowOpacity = 1.0
        AceeptBtn.layer.shadowRadius = 2.0
        AceeptBtn.layer.masksToBounds = false
        AceeptBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        DenyBtn.layer.cornerRadius =  15.0
        DenyBtn.layer.shadowColor = UIColor.lightGray.cgColor
        DenyBtn.layer.shadowOpacity = 1.0
        DenyBtn.layer.shadowRadius = 2.0
        DenyBtn.layer.masksToBounds = false
        DenyBtn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
