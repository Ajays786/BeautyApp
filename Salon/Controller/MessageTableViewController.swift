//
//  MessageTableViewController.swift
//  Salon
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MessageTableViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var db: Firestore!
    var message: [MessageModel] = [] {
        didSet {
            self.Tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    SearchBar.backgroundImage = UIImage()
        self.loadMessage()
    }
    
    // MARK: - Load data
    func loadMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print(uid)
        db = Firestore.firestore()
        
        let dealsRef = db.collection("chat").document(uid)
        dealsRef.addSnapshotListener { (snapshot, error) in
            self.reloadDB()
        }
    }
    
    func reloadDB() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        self.message.removeAll()
        db = Firestore.firestore()
        let dealsRef = db.collection("chat").document(uid)
        dealsRef.getDocument { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            print("lhy has doc.data() \(doc.data())")
            for (reservationID, _) in doc.data() ?? [:] {
                let detailRef = self.db.collection("chatDetail").document(reservationID)
                detailRef.getDocument(completion: { (sn, err) in
                    guard err == nil, let sn = sn else {
                        return
                    }
                    var data = sn.data()
                    data?["reservationID"] = reservationID
                    self.message.append(MessageModel(data: data ?? [:]))
                    print(self.message)
                })
            }
        }
    }

    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return message.count
        return 7
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userMessageCell", for: indexPath) as! MessageTableViewCell
//        let info = message[indexPath.row]
//        
//        cell.nameLabel.text = info.merchantName

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let info = message[indexPath.row]
//        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.reservationID = info.reservationID
//        chatLogController.temTitle = info.merchantName
//        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
