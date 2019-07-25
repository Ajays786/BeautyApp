//
//  DealTableViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 2018/8/28.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import ImageSlideshow
import CoreLocation
class DealTableViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ImageSlideShow: ImageSlideshow!
     let localSource = [ImageSource(imageString: "Image_dryer")!, ImageSource(imageString: "Image_lip")!, ImageSource(imageString: "WaxingImage")!,  ImageSource(imageString: "Hair - Beauty shot 1 for")!,ImageSource(imageString: "DogImage")! ,ImageSource(imageString: "FacialImage")!]
    
    
    var db: Firestore!
    var deals: [DealModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
         ImageSlideShow.draggingEnabled = false
        
        ImageSlideShow.slideshowInterval = 5.0
        ImageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        ImageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(r:85,g:211,b:199)
        ImageSlideShow.pageIndicator = pageControl
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        ImageSlideShow.activityIndicator = DefaultActivityIndicator()
        //        ImageSlideShow.delegate = self
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        ImageSlideShow.setImageInputs(localSource)
        // Do any additional setup after loading the view.
        
        
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        let backgroundImageView = UIImageView(frame: self.view.bounds)
//        backgroundImageView.image = #imageLiteral(resourceName: "Back")
//        view.insertSubview(backgroundImageView, at: 0)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
//        navigationController?.navigationBar.frame = CGRect(origin: navigationController!.navigationBar.frame.origin, size: CGSize(width: navigationController!.navigationBar.frame.width, height: navigationController!.navigationBar.frame.height + 30))
//        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Back"), for: UIBarMetrics.default)
////        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.view.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.tintColor = UIColor.white
        
        loadTable()
        checkIfUserIsLoggedIn()
    }
    
    func loadTable() {
        db = Firestore.firestore()
        
        let dealsRef = db.collection("BeautyMatchOffer")
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            for change in doc.documentChanges {
                print(change.document.data())
                let temDeal = DealModel(data: change.document.data())
                self.deals.append(temDeal)
            }
        }
    }
    
    @IBAction func rightNavigationItemAction(_ sender: Any) {
        self.newAppointment()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            // add delay to solve the warning message "Unbalanced calls to begin"
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            // Ask for registor remote notification
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.registerRemoteNotification(UIApplication.shared)
        }
    }
    
    @objc func handleLogout() {
        do {
            if let uid = Auth.auth().currentUser?.uid {
//                Firestore.firestore().collection("user").document(uid).
                print("Deleted user past token")
               
            } else {
                print("No user token have to be deleted")
            }
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
//        let loginController = LoginViewController()
        
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logViewController") as! LogViewController
        
        let navController = UINavigationController(rootViewController: loginController)
        navController.navigationBar.barStyle = .blackTranslucent
        present(navController, animated: true)
    }
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as! DealTableViewCell
        let dealObject = deals[indexPath.row]
        db = Firestore.firestore()
        let dealsRef = db.collection("user").document(dealObject.uid)
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot, let dic = doc.data() else {
                print(error)
                return
            }
            if let latitude = dic["lat"] as? String, let longitude = dic["long"] as? String{
                let buddylat = Double(latitude)
                let buddylong = Double(longitude)
                let addresss = self.getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
                print("address",addresss)
//                cell.address.text = addresss
                let myLocation = CLLocation(latitude: lat, longitude: long)
                let mybuddyLocation = CLLocation(latitude: buddylat!, longitude: buddylong!)
                let Distance = self.CalculateDistance(MyLocation: myLocation, MybuddyLocation: mybuddyLocation)
                cell.Miles.text = "\(round(Distance))" + " Miles"
                dealObject.Miles.append(cell.Miles.text!)
            }
            
        }
 
        cell.name.text = dealObject.Name
        cell.price.text = dealObject.PromoPrice
        print(dealObject.uid)
        cell.time.text = "\(dealObject.TimeDate.prefix(8))"
        cell.tag = indexPath.row
        cell.Date.text = "\(dealObject.TimeDate.suffix(8))"
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)->String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var Address = String()
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country ?? "placemarks is nill")
                    print(pm.locality ?? "locality is nill")
                    print(pm.subLocality ?? "subLocality is nill")
                    print(pm.thoroughfare ?? "thoroughfare is nill")
                    print(pm.postalCode ?? "postalCode is nill")
                    print(pm.subThoroughfare ?? "subThoroughfare is nill")
                    
                    
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                        //                        self.Locality = pm.subLocality ?? "nil"
                    }
                    //                    if pm.thoroughfare != nil {
                    //                        addressString = addressString + pm.thoroughfare! + ", "
                    //                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        //                        self.Locality.append(", "+pm.locality!)
                    }
                    
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                       
                    }
                    if pm.country != nil {
                        //                        addressString = addressString + pm.country! + ", "
                    }
                    
                  Address = addressString
                    print(addressString)
                }
        })
        return Address
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dealCell = sender as? DealTableViewCell {
            let desTVC = segue.destination as! SalonDetailTableViewController
            desTVC.info = deals[dealCell.tag]
        }
    }
    @IBAction func MessageAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageTableViewController") as! MessageTableViewController
//        
//        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    

}
