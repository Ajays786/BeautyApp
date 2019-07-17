//
//  BidDetailTableViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 9/28/18.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import PassKit
import Stripe

class BidDetailTableViewController: UITableViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    lazy var functions = Functions.functions()
    
    var db: Firestore!
    var id: String!
    var bids: [BidDetailModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTable()
    }
    
    func loadTable() {
        db = Firestore.firestore()
        
        let dealsRef = db.collection("reservation").document(id).collection("offers")
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            for change in doc.documentChanges {
                guard change.type == .added else {
                    continue
                }
                print(change.document.data())
                let temDeal = BidDetailModel(data: change.document.data())
                self.bids.append(temDeal)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bidDetailCell", for: indexPath)
        let dealObject = bids[indexPath.row]
        
        cell.detailTextLabel?.text = dealObject.price
        cell.textLabel?.text = dealObject.uid
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dealObject = bids[indexPath.row]
        let alertVC = UIAlertController(title: "Accecpt this Bid?", message: "Accepting means...", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Accecpt and Pay", style: .default, handler: { (_) in
//            self.openApplyPay(uid: dealObject.uid)
            self.handleMakeBid(chosen: dealObject.uid)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func openApplyPay(uid: String) {
        let paymentNetworks:[PKPaymentNetwork] = [.amex,.masterCard,.visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = "merchant.com.liuhengyu.salon"
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.supportedNetworks = paymentNetworks
            request.requiredShippingContactFields = [.name, .postalAddress]
            // This is based on using Stripe
            request.merchantCapabilities = .capability3DS
            
            let salon = PKPaymentSummaryItem(label: "Salon Reservation", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal:0.30), type: .final)
            let total = PKPaymentSummaryItem(label: "APPGYN", amount: NSDecimalNumber(decimal:1.30), type: .final)
            request.paymentSummaryItems = [salon, tax, total]
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            if let viewController = authorizationViewController {
                viewController.delegate = self
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        // Let the Operating System know that the payment was accepted successfully
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        STPAPIClient.shared().createToken(with: payment) { (stripeToken, error) in
            guard error == nil, let stripeToken = stripeToken else {
                print(error!)
                return
            }
            let apiUrl = URL(string:"https://salon-test.herokuapp.com/pay")!
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let body:[String : Any] = ["stripeToken" : stripeToken.tokenId,
                                       "amount" : 130,
                                       "description" : "Purchase for salon reservation"]
            try? request.httpBody = JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard error == nil else {
                    print (error!)
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }

                guard let response = response else {
                    print ("Empty or erronous response")
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }

                print (response)

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Once the payment is successful, show the user that the purchase has been successful
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                } else {
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                }
            }

            task.resume()
        }
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss the Apple Pay UI
        dismiss(animated: true, completion: nil)
    }

}

extension BidDetailTableViewController {
    func handleMakeBid(chosen: String) {
        let par: [String: AnyObject] = [
            "reservation": id as AnyObject,
            "chosen": chosen as AnyObject,
        ]
        functions.httpsCallable("chooseBid").call(par) { _, _ in
            // Ignore errors for now
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
}
