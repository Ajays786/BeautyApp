//
//  MyTableViewController.swift
//  Salon
//
//  Created by mac on 2018/8/19.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyTableViewController: UITableViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutCell: UITableViewCell!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
        userAvatarImageView.layer.cornerRadius = 5
    }
    
    func loadUserProfile() {
        db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            handleLogout()
            return
        }
        db.collection("user").document(uid).addSnapshotListener { (snap, err) in
            guard err == nil, let name = snap?.data()?["name"] as? String else {
                print(err)
                self.usernameLabel.text = "Error"
                return
            }
            self.usernameLabel.text = name
            if let image = snap?.data()?["icon"] as? String {
                var ref = Storage.storage().reference(withPath: "profile_images")
                ref = ref.child(image+".png")
                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                    } else {
                        let imageV = UIImage(data: data!)
                        self.userAvatarImageView.image = imageV
                    }
                }
            }
        }
    }
    
    @objc func handleLogout() {
        do {
            if let uid = Auth.auth().currentUser?.uid {
//                Database.database().reference().child("users").child(uid).child("token").removeValue()
                print("Deleted user past token")
            } else {
                print("No user token have to be deleted")
            }
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logViewController") as! LogViewController
        let navController = UINavigationController(rootViewController: loginController)
        navController.navigationBar.barStyle = .blackTranslucent
        present(navController, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.cellForRow(at: indexPath) == logoutCell {
            self.handleLogout()
        }
    }
    
    
}
