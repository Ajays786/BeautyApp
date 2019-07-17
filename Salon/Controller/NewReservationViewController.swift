//
//  NewReservationViewController.swift
//  Salon
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class NewReservationViewController: FormViewController {
    
    lazy var functions = Functions.functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Appointment"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reserve", style: .done, target: self, action: #selector(handleCreate))
        form +++ Section("Salon")
            <<< TextRow() { row in
                row.tag = "style"
                row.title = "Perferred style"
                row.placeholder = "Enter text here"
            }
            <<< DateRow() {
                $0.tag = "date"
                $0.title = "Perferred date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            +++ Section("Personal info")
            <<< PhoneRow() {
                $0.tag = "phone"
                $0.title = "Phone number"
                $0.placeholder = "Enter text here"
            }
            <<< TextRow() { row in
                row.tag = "name"
                row.title = "Name"
                row.placeholder = "Enter your name here"
            }
    }
    
    @objc func handleCreate() {
        guard let style = (self.form.rowBy(tag: "style") as! TextRow).value else {
                let alert = UIAlertController(title: "Please enter all info", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let par: [String: AnyObject] = [
            "style": style as AnyObject,
        ]
        functions.httpsCallable("makeReservation").call(par) { _, _ in
            // Ignore errors for now
            self.cancel()
            return
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

