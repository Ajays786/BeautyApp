//
//  BidTableViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 9/28/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BidTableViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var Data = [0,1,2,3,4,5]
    
    var db: Firestore!
    var bids: [(String, BidModel)] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        let backgroundImageView = UIImageView(frame: self.view.bounds)
//        backgroundImageView.image = #imageLiteral(resourceName: "Back")
//        view.insertSubview(backgroundImageView, at: 0)
        loadTable()
    }
    
    func loadTable() {
        db = Firestore.firestore()
        
        let dealsRef = db.collection("reservation")
        dealsRef.addSnapshotListener { (snapshot, error) in
            self.reloadDB()
        }
        
    }
    
    func reloadDB() {
        self.bids.removeAll()
        db = Firestore.firestore()
        let dealsRef = db.collection("reservation")
        dealsRef.getDocuments { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            for d in doc.documents {
                let id = d.documentID
                let temDeal = BidModel(data: d.data())
                self.bids.append((id, temDeal))
            }
        }
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("lhy \(bids.count)")
//        return bids.count
        return Data.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bidCell", for: indexPath) as! BidTableViewCell
        cell.AceeptBtn.tag = indexPath.row
        cell.DenyBtn.tag = indexPath.row
        cell.AceeptBtn.addTarget(self, action: #selector(Accept), for:.touchUpInside)
        cell.DenyBtn.addTarget(self, action: #selector(Deny), for:.touchUpInside)
//        let dealObject = bids[indexPath.row]
//        cell.tag = indexPath.row
//
//
//        cell.textLabel?.text = dealObject.1.style
//        if dealObject.1.status {
//            cell.detailTextLabel?.text = "Pending"
//        } else {
//            cell.detailTextLabel?.text = "Biding"
//        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.cellForRow(at: indexPath)?.isSelected = false
//       let vc = self.storyboard?.instantiateViewController(withIdentifier: "SalonDetailTableViewController") as! SalonDetailTableViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
//        let dealObject = bids[indexPath.row]
//        if dealObject.1.status {
//            let alert = UIAlertController(title: "Waiting merchant to confirm", message: dealObject.1.chosen, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            self.performSegue(withIdentifier: "bidDetail", sender: tableView.cellForRow(at: indexPath))
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 28
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 28
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bidDetail" {
            let cell = sender as! UITableViewCell
            let detailController = segue.destination as! BidDetailTableViewController
            detailController.id = bids[cell.tag].0
        }
    }
    //Accept Offer
    
    @objc func Accept(sender:UIButton){
        tableView.beginUpdates()
        var index = IndexPath()
        index = [0,sender.tag]
        Data.remove(at: sender.tag)
        tableView.deleteRows(at: [index], with: .left)
        //TODO ... add your code to update data source here
        tableView.endUpdates()
        tableView.reloadData()
        print(sender.tag)
        print("Accept")
    }
    
    
      //Deny Offer
    
    @objc func Deny(sender:UIButton){
        tableView.beginUpdates()
        var index = IndexPath()
        index = [0,sender.tag]
        Data.remove(at: sender.tag)
        tableView.deleteRows(at: [index], with: .right)
        //TODO ... add your code to update data source here
        tableView.endUpdates()
          tableView.reloadData()
        print(sender.tag)
        print("Deny")
    }
    
    @IBAction func MessageAction(_ sender: Any) {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageTableViewController") as! MessageTableViewController
//
//                self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
