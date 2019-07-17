//
//  ProfessionalsViewController.swift
//  Salon
//
//  Created by Rahul Tiwari on 5/6/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase
class ProfessionalsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var db: Firestore!
    var deals: [ProModel] = [] {
        didSet {
           TableView.reloadData()
        }
    }
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
   SearchBar.backgroundImage = UIImage()
        loadTable()
        // Do any additional setup after loading the view.
    }
    
    func loadTable() {
        db = Firestore.firestore()
        
        let dealsRef = db.collection("user")
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            for change in doc.documentChanges {
                print(change.document.data())
                let temDeal = ProModel(data: change.document.data())
                self.deals.append(temDeal)
            }
        }
    }
    
    // MARK:- Table Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfCell") as! ProfessionalsTableViewCell
        cell.selectionStyle = .none
        cell.Name.text = deals[indexPath.row].name
        var ref = Storage.storage().reference(withPath: "profile_images")
        ref = ref.child(deals[indexPath.row].icon ?? ""+".png")
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(self.deals[indexPath.row].icon,"eroooooor",ref)
            } else {
                let imageV = UIImage(data: data!)
                cell.ProfileImage.image = imageV
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SalonDetailTableViewController") as! SalonDetailTableViewController
        vc.ControllerName = "Professionals"
        self.navigationController?.pushViewController(vc, animated: true)
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func MessageActionButton(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageTableViewController") as! MessageTableViewController
////        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
