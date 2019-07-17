//
//  DealReceivedViewController.swift
//  Salon
//
//  Created by Rahul Tiwari on 3/27/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit

class DealReceivedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func CancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AcceptBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
