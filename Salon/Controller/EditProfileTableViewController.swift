//
//  EditProfileTableViewController.swift
//  Salon
//
//  Created by 刘恒宇.
//  Copyright © 2018 Hengyu Liu. All rights reserved.
//
       
import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
var lat = Double()
var long = Double()
class EditProfileTableViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var NameEditButton: UIButton!
    @IBOutlet weak var TransactionBtn: LoadingButton!
     var locationManager = CLLocationManager()
    @IBOutlet weak var SearchBtn: LoadingButton!
    @IBOutlet weak var LogOutBtn: LoadingButton!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var iconCell: UITableViewCell!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!{
        didSet{
            loadUserProfile()
//            if let image = snap?.data()?["icon"] as? String {
//                var ref = Storage.storage().reference(withPath: "profile_images")
//                ref = ref.child(image+".png")
//                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                    if let error = error {
//                    } else {
//                        let imageV = UIImage(data: data!)
//                        self.ProfilePicture.image = imageV
//                    }
//                }
//            }
        }
        
    }
    
    @IBOutlet weak var SettingsBtn: LoadingButton!
    
    @IBOutlet weak var HappyHourBtn: LoadingButton!
    
    @IBOutlet weak var ScheduleAppointmentBtn: LoadingButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            print("startUpdatingLocation...............")
            let myLocation = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            let dealsRef = db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
            lat = myLocation.coordinate.latitude
            long = myLocation.coordinate.longitude
            dealsRef.updateData(["lat": "\(myLocation.coordinate.latitude)" as Any, "long": "\(myLocation.coordinate.longitude)" as Any])
        }

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = #imageLiteral(resourceName: "Setting-bg")
        view.insertSubview(backgroundImageView, at: 0)
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        let backgroundImageView = UIImageView(frame: self.view.bounds)
//        backgroundImageView.image = #imageLiteral(resourceName: "Back")
//        view.insertSubview(backgroundImageView, at: 0)
//        let Message = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(MessageTapped))
//        Message.image = #imageLiteral(resourceName: "message")
        //SearchBtn shadow
        SearchBtn.layer.shadowColor = UIColor.white.cgColor
        SearchBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        SearchBtn.layer.shadowRadius = 5
        SearchBtn.layer.cornerRadius = SearchBtn.frame.height/2
        SearchBtn.layer.shadowOpacity = 5.0
        
        // Schedule Shadow
        ScheduleAppointmentBtn.layer.shadowColor = UIColor.white.cgColor
        ScheduleAppointmentBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        ScheduleAppointmentBtn.layer.shadowRadius = 5
         ScheduleAppointmentBtn.layer.cornerRadius = ScheduleAppointmentBtn.frame.height/2
        ScheduleAppointmentBtn.layer.shadowOpacity = 5.0
        
        // HappyHour Shadow
        HappyHourBtn.layer.shadowColor = UIColor.white.cgColor
        HappyHourBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        HappyHourBtn.layer.shadowRadius = 5
        HappyHourBtn.layer.cornerRadius = HappyHourBtn.frame.height/2
        HappyHourBtn.layer.shadowOpacity = 5.0
        
        
        // Settings Shadow
        SettingsBtn.layer.shadowColor = UIColor.white.cgColor
        SettingsBtn.layer.shadowOffset = CGSize(width: 2, height:2)
        SettingsBtn.layer.shadowRadius = 5
        SettingsBtn.layer.cornerRadius = SettingsBtn.frame.height/2
        SettingsBtn.layer.shadowOpacity = 5.0
        
        // Settings Shadow
        TransactionBtn.layer.shadowColor = UIColor.white.cgColor
        TransactionBtn.layer.shadowOffset = CGSize(width: 2, height:2)
        TransactionBtn.layer.shadowRadius = 5
        TransactionBtn.layer.cornerRadius = SettingsBtn.frame.height/2
        TransactionBtn.layer.shadowOpacity = 5.0
        
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.width/2
        ProfilePicture.layer.borderWidth = 1
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor.black.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.height/2
        ProfilePicture.clipsToBounds = true
//        ScheduleAppointmentBtn
//        lo
//        navigationItem.rightBarButtonItems = [Message]
        self.title = "Profile"

//        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
        ProfilePicture.isUserInteractionEnabled = true
        ProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
       
         checkIfUserIsLoggedIn()
        
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        
//         self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            // add delay to solve the warning message "Unbalanced calls to begin"
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            // Ask for registor remote notification
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.registerRemoteNotification(UIApplication.shared)
               loadTable()
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
    func loadUserProfile() {
        db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
//            handleLogout()
            return
        }
        db.collection("user").document(uid).addSnapshotListener { (snap, err) in
            guard err == nil, let name = snap?.data()?["name"] as? String else {
                print(err)
                self.NameLabel.text = "Error"
                return
            }
            self.NameLabel.text = name
            if let image = snap?.data()?["icon"] as? String {
                var ref = Storage.storage().reference(withPath: "profile_images")
                ref = ref.child(image+".png")
                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                    } else {
                        let imageV = UIImage(data: data!)
                        self.ProfilePicture.image = imageV
                    }
                }
            }
        }
    }
    func loadTable() {
        db = Firestore.firestore()
        
        let dealsRef = db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot, let dic = doc.data() else {
                print(error)
                return
            }
            if let name = dic["name"] as? String{
                self.NameLabel.text = name
            } else {
                self.NameLabel.text = "N/A"
            }
//            if let email = Auth.auth().currentUser?.email{
//                self.emailCell.textLabel?.text = email
//            } else {
//                self.emailCell.textLabel?.text = "N/A"
//            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
     
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath == tableView.indexPath(for: iconCell) {
//
//            handleSelectProfileImageView()
//
//        } else if indexPath == tableView.indexPath(for: emailCell) {
//            let alert = UIAlertController(title: "New Email", message: "", preferredStyle: .alert)
//            alert.addTextField { (textField) in
//                textField.placeholder = "Enter You New Email"
//            }
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//                if let te = alert.textFields![0].text {
//                    if te.count > 0 {
//                        Auth.auth().currentUser?.updateEmail(to: te, completion: nil)
//                    }
//                }
//
//            }))
//            present(alert, animated: true) {
//                self.tableView.deselectRow(at: indexPath, animated: true)
//            }
//        } else if indexPath == tableView.indexPath(for: nameCell) {
//            let alert = UIAlertController(title: "New Name", message: "", preferredStyle: .alert)
//            alert.addTextField { (textField) in
//                textField.placeholder = "Enter You New Name"
//            }
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//                if let te = alert.textFields![0].text {
//                    if te.count > 0 {
//                        self.db = Firestore.firestore()
//                        let dealsRef = self.db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
//                        dealsRef.updateData(["name": te as Any])
//                    }
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(alert, animated: true) {
//                self.tableView.deselectRow(at: indexPath, animated: true)
//            }
//        }
//    }
    
    @IBAction func NotificationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    @objc func MessageTapped(){
        print("MESSAGE TAPPED")
       
    }
    @IBAction func NameEditAction(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Update Name", message: "Enter new name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            // Force unwrapping because we know it exists.
            if ((textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines)) != ""){
                let userID = Auth.auth().currentUser!.uid
                let dealsRef = self.db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
                dealsRef.updateData(["name": textField?.text as Any])
                self.loadTable()
//                self.updateUserName(withUid: userID, toNewName: (textField?.text)!)
            
            }
            else{
                self.alert(message: "Please enter valid name ")
            }
            print("Text field: \(textField?.text)")
            //Send Reset Password Link
            //
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //Upadate Name
    
    func updateUserName(withUid: String, toNewName: String) {
        
        self.db.collection("users").document(withUid).setData( ["name": toNewName], merge: true)
    }
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        self.ProfilePicture.image = selectedImageFromPicker
        if let selectedImage = selectedImageFromPicker {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.1) {
                // change to JPEG for better compression, current resolution: 0.1
                storageRef.putData(uploadData, metadata: nil, completion: { metadata, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let dealsRef = self.db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
                    dealsRef.updateData(["icon": imageName as Any])
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func HappyHourButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func ScheduleAppointMentAction(_ sender: Any) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleAppontmentController") as! ScheduleAppontmentController
        vc.UserName = self.NameLabel.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func SearchAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalsViewController") as! ProfessionalsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func TransactionAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LogOutAction(_ sender: Any) {
        do {
            if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).child("token").removeValue()
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
//        navController.navigationBar.barStyle = .blackTranslucent
        present(navController, animated: true)
//        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    
}
