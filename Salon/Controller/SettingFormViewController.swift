//
//  SettingFormViewController.swift
//  Salon
//
//  Created by mac on 2018/8/21.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Eureka
import ImageSlideshow
import CoreLocation
import Firebase
import FirebaseFirestore
import McPicker
class SettingFormViewController: BaseViewController,UINavigationControllerDelegate,ZipDelegate{
   
    var left = 0
    var Right = 0
    let BeutySpecilaColor = UIColor(r:85,g:211,b:199)
    var locManager = CLLocationManager()
     var db: Firestore!
     lazy var functions = Functions.functions()
    var currentLocation: CLLocation!
    @IBOutlet weak var HairBtn: UIButton!
    @IBOutlet weak var SpaBtn: UIButton!
    @IBOutlet weak var NailsBtn: UIButton!
    @IBOutlet weak var TanningBtn: UIButton!
    @IBOutlet weak var EnterDistanceText: UITextField!
    @IBOutlet weak var ZipText: UITextField!
    @IBOutlet weak var NotificationBtn: UIButton!
    @IBOutlet weak var DogGrommingBtn: UIButton!
    @IBOutlet weak var NoticationSwitchBtn: UISwitch!
    
    @IBOutlet weak var SkinCareBtn: UIButton!
    @IBOutlet weak var WaxBtn: UIButton!
    @IBOutlet weak var EyelashBtn: UIButton!
    @IBOutlet weak var EyebrowBrn: UIButton!
    @IBOutlet weak var MakeupBtn: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
     let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var Services = [String]()
    var Notification = false
    var DistnaceArray = [String]()
     var Setting: [Settings] = []
    @IBOutlet weak var ImageSlideShow: ImageSlideshow!
    let localSource = [ImageSource(imageString: "Image_dryer")!, ImageSource(imageString: "Image_lip")!, ImageSource(imageString: "WaxingImage")!,  ImageSource(imageString: "Hair - Beauty shot 1 for")!,ImageSource(imageString: "DogImage")! ,ImageSource(imageString: "FacialImage")!]
    var ZipCode = String()
    @IBOutlet weak var SaveBtn: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
       ImageSlideShow.draggingEnabled = false
        let Insets:CGFloat = 8.0
         HairBtn.contentVerticalAlignment = .fill
         HairBtn.contentHorizontalAlignment = .fill
         HairBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        SpaBtn.contentVerticalAlignment = .fill
        SpaBtn.contentHorizontalAlignment = .fill
        SpaBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        NailsBtn.contentVerticalAlignment = .fill
        NailsBtn.contentHorizontalAlignment = .fill
        NailsBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        TanningBtn.contentVerticalAlignment = .fill
        TanningBtn.contentHorizontalAlignment = .fill
        TanningBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        DogGrommingBtn.contentVerticalAlignment = .fill
        DogGrommingBtn.contentHorizontalAlignment = .fill
        DogGrommingBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        SkinCareBtn.contentVerticalAlignment = .fill
        SkinCareBtn.contentHorizontalAlignment = .fill
        SkinCareBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        EyebrowBrn.contentVerticalAlignment = .fill
        EyebrowBrn.contentHorizontalAlignment = .fill
        EyebrowBrn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        EyelashBtn.contentVerticalAlignment = .fill
        EyelashBtn.contentHorizontalAlignment = .fill
        EyelashBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        WaxBtn.contentVerticalAlignment = .fill
        WaxBtn.contentHorizontalAlignment = .fill
        WaxBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        MakeupBtn.contentVerticalAlignment = .fill
        MakeupBtn.contentHorizontalAlignment = .fill
        MakeupBtn.imageEdgeInsets = UIEdgeInsetsMake(Insets, Insets, Insets, Insets)
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            self.getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")
        }
         loadTable()
        ImageSlideShow.slideshowInterval = 5.0
        ImageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        ImageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
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
        
        
//            self.navigationController?.navigationBar.prefersLargeTitles = false
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController?.navigationBar.shadowImage = UIImage()
//            self.navigationController?.navigationBar.isTranslucent = true
//            self.navigationController?.view.backgroundColor = .clear
//            let backgroundImageView = UIImageView(frame: self.view.bounds)
//            backgroundImageView.image = #imageLiteral(resourceName: "Back")
//            view.insertSubview(backgroundImageView, at: 0)
        SaveBtn.layer.cornerRadius = SaveBtn.frame.height/2
        SaveBtn.layer.shadowColor = UIColor.lightGray.cgColor
        SaveBtn.layer.shadowOpacity = 2.0
        
        HairBtn.layer.shadowColor = UIColor.lightGray.cgColor
        HairBtn.layer.shadowOpacity = 2.0
        
        SpaBtn.layer.shadowColor = UIColor.lightGray.cgColor
        SpaBtn.layer.shadowOpacity = 2.0
        
        NailsBtn.layer.shadowColor = UIColor.lightGray.cgColor
        NailsBtn.layer.shadowOpacity = 2.0
        
        TanningBtn.layer.shadowColor = UIColor.lightGray.cgColor
        TanningBtn.layer.shadowOpacity = 2.0
        
        DogGrommingBtn.layer.shadowColor = UIColor.lightGray.cgColor
        DogGrommingBtn.layer.shadowOpacity = 2.0
//        ImageSlideshow.layer.shadowColor = UIColor.lightGray.cgColor
//        ImageSlideshow.layer.shadowOpacity = 2.0
            /*
            form +++ Section("Section1")
                <<< TextRow(){ row in
                    row.title = "Text Row"
                    row.placeholder = "Enter text here"
                }
                <<< PhoneRow(){
                    $0.title = "Phone Row"
                    $0.placeholder = "And numbers here"
                }
                +++ Section("Distance")
                <<< DateRow(){
                    $0.title = "Date Row"
                    $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
 */
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        setupKeyboardObservers()
    }
    
    func loadTable() {
        self.uiBusy.startAnimating()
        db = Firestore.firestore()
        let dealsRef = db.collection("Settings").document(String(describing: Auth.auth().currentUser!.uid))
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot else {
                print(error!)
                return
            }
            if doc.data() != nil{
                print(doc.data())
                let Setting = Settings(data: doc.data()!)
                print(Setting)
                self.ZipText.text = Setting.Zip
                self.EnterDistanceText.text = Setting.Distance
                self.NoticationSwitchBtn.isOn = Setting.Notification
                self.Notification = Setting.Notification
                self.SetServices(Services: Setting.Services)
                self.uiBusy.stopAnimating()
            }
          
//            for change in doc.documentChanges {
////                change.document.data(with: <#T##ServerTimestampBehavior#>)
//                print(change.document.data())
//                let data = change.document.data()
//                print(data)
////                let temDeal = DealModel(data: change.document.data())
////                print(temDeal)
//            }
        }
    }
    
    func deleteSettingRefrence(handleComplete:@escaping (()->())){
        db = Firestore.firestore()
        let dealsRef = db.collection("Settings").whereField("userID", isEqualTo: String(describing: Auth.auth().currentUser!.uid))
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot else {
                  handleComplete()
                print("handleComplete()1")
                print(error!)
                return
            }
            if doc.documentChanges.count==0{
                handleComplete()
                 print("handleComplete()2")
            }
            for change in doc.documentChanges {
               change.document.reference.delete()
                print("Deleted")
                if doc.documentChanges.endIndex == doc.documentChanges.count{
                  handleComplete()
                     print("handleComplete()3")
                }
            }
           
        
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func AddDistanceToArray(){
        for  i in (0..<26){
            if  i == 1{
                DistnaceArray.append("\(i)"+"  Mile")
            }
            else{
                DistnaceArray.append("\(i)"+"  Miles")
            }
            
        }
    }
    
    @IBAction func ZipAction(_ sender: Any) {
        let SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        SearchViewController.Delegate = self
         SearchViewController.SearchText = ZipCode
        self.present(SearchViewController, animated: true, completion: nil)
    }
    
    //Zip delegate
    func LocationOrzip(Zip: String) {
        ZipText.text = Zip
    }
    
    func CreatePricePIcker(){
        let mcPicker = McPicker(data: [DistnaceArray])
        
        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = .white
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!
        mcPicker.label = customLabel // Set your custom label
        
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Select") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        
        mcPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!
        
        mcPicker.toolbarButtonsColor = .white
        mcPicker.toolbarBarTintColor = self.BeutySpecilaColor
        mcPicker.pickerBackgroundColor = self.BeutySpecilaColor
        mcPicker.backgroundColor = UIColor.clear
        mcPicker.backgroundColorAlpha = 0.50
        //        mcPicker.pickerSelectRowsForComponents = [
        //            0: [3: true],
        //            1: [2: true] // [Component: [Row: isAnimated]
        //        ]
        
        //        if let barButton = sender as? UIBarButtonItem {
        //            // Show as Popover
        //            //
        //            mcPicker.showAsPopover(fromViewController: self, barButtonItem: barButton) { [weak self] (selections: [Int : String]) -> Void in
        //                if let prefix = selections[0], let name = selections[1] {
        //                    self?.label.text = "\(prefix) \(name)"
        //                }
        //            }
        //        }
        //        else {
        // Show Normal
        //
        /*
         mcPicker.show { [weak self] selections in
         if let prefix = selections[0], let name = selections[1] {
         self?.label.text = "\(prefix) \(name)"
         }
         }
         */
        mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            if let prefix = selections[0] {
                self?.EnterDistanceText.text =  prefix
            }
            }, cancelHandler: {
                print("Canceled Styled Picker")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Component \(componentThatChanged) changed value to \(newSelection)")
        })
    }
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: keyboardDuration!, animations: {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y = ((self.view.frame.height - (self.SaveBtn.frame.maxY + 12 + keyboardHeight)) > -100) && ((self.view.frame.height - (self.SaveBtn.frame.maxY + 12 + keyboardHeight)) < 0) ? (self.view.frame.height - (self.SaveBtn.frame.maxY + 12 + keyboardHeight)) : -200
            } else {
                self.view.frame.origin.y = -200
            }
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
         self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    @objc func resignKeyboard() {
        EnterDistanceText.resignFirstResponder()
        ZipText.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//        repeatTextField.resignFirstResponder()
    }

    @IBAction func HairAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "hair-grey"){
            sender.setImage(UIImage(named: "hair"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object:"Hair")
        }
        else if sender.currentImage ==  UIImage(named: "hair"){
            sender.setImage(UIImage(named: "hair-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
             self.Services.index(of:"Hair").map{self.Services.remove(at: $0)}
        }
    }
    @IBAction func SpaAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "spa-grey"){
            sender.setImage(UIImage(named: "spa"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object:"Spa")
        }
        else if sender.currentImage ==  UIImage(named: "spa"){
            sender.setImage(UIImage(named: "spa-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
             self.Services.index(of:"Spa").map{self.Services.remove(at: $0)}
        }

    }
    @IBAction func NailsAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "nail-gey"){
            sender.setImage(UIImage(named: "nailpaint"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object:"Nails")

        }
        else if sender.currentImage ==  UIImage(named: "nailpaint"){
            sender.setImage(UIImage(named: "nail-gey"), for: .normal)
            sender.backgroundColor = UIColor.white
             self.Services.index(of:"Nails").map{self.Services.remove(at: $0)}
        }
    }
    @IBAction func TanningAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "tanning-grey"){
            sender.setImage(UIImage(named: "tanning"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object:"Tanning")
            
        }
        else if sender.currentImage ==  UIImage(named: "tanning"){
            sender.setImage(UIImage(named: "tanning-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Tanning").map{self.Services.remove(at: $0)}
        }
    }
  
    @IBAction func NotidicationAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "notification-grey"){
            sender.setImage(UIImage(named: "notifications"), for: .normal)
            
        }
        else if sender.currentImage ==  UIImage(named: "notifications"){
            sender.setImage(UIImage(named: "notification-grey"), for: .normal)
            
           
        }
        

    }
    @IBAction func NotificationSwitch(_ sender: UISwitch) {
        if sender.isOn{
            self.Notification = true
        }
        else{
            self.Notification = false
        }
        
    }
    @IBAction func DogGrommingAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "Dog-grey"){
            sender.setImage(UIImage(named: "Dog"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
             self.Services.appendUniqueObject(object: "Dog Grooming")
            
        }
        else if sender.currentImage ==  UIImage(named: "Dog"){
            sender.setImage(UIImage(named: "Dog-grey"), for: .normal)
             sender.backgroundColor = UIColor.white
             self.Services.index(of:"Dog Grooming").map{self.Services.remove(at: $0)}
            
        }
        
    }
    @IBAction func SkinCareAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "Skin-grey"){
            sender.setImage(UIImage(named: "Skin"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object: "Skin Care")
            
        }
        else if sender.currentImage ==  UIImage(named: "Skin"){
            sender.setImage(UIImage(named: "Skin-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Skin Care").map{self.Services.remove(at: $0)}
            
        }
        
    }
    @IBAction func WaxAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "wax-grey"){
            sender.setImage(UIImage(named: "wax"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object: "Wax")
            
        }
        else if sender.currentImage ==  UIImage(named: "wax"){
            sender.setImage(UIImage(named: "wax-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Wax").map{self.Services.remove(at: $0)}
            
        }
        
    }
    @IBAction func EyelashAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "eyelash-grey"){
            sender.setImage(UIImage(named: "eyelash"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object: "Eyelash")
            
        }
        else if sender.currentImage ==  UIImage(named: "eyelash"){
            sender.setImage(UIImage(named: "eyelash-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Eyelash").map{self.Services.remove(at: $0)}
            
        }
        
    }
    @IBAction func EyebroAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "Eyebrow-grey"){
            sender.setImage(UIImage(named: "Eyebrow"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object: "Eyebrow")
            
        }
        else if sender.currentImage ==  UIImage(named: "Eyebrow"){
            sender.setImage(UIImage(named: "Eyebrow-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Eyebrow").map{self.Services.remove(at: $0)}
            
        }
        
    }
    @IBAction func MakeupAction(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "make_up-grey"){
            sender.setImage(UIImage(named: "make_up"), for: .normal)
            sender.backgroundColor = self.BeutySpecilaColor
            self.Services.appendUniqueObject(object: "Make Up")
            
        }
        else if sender.currentImage ==  UIImage(named: "make_up"){
            sender.setImage(UIImage(named: "make_up-grey"), for: .normal)
            sender.backgroundColor = UIColor.white
            self.Services.index(of:"Make Up").map{self.Services.remove(at: $0)}
            
        }
        
    }
    
    
    @IBAction func SaveAction(_ sender: UIButton) {
        if HairBtn.backgroundColor != BeutySpecilaColor && SpaBtn.backgroundColor != BeutySpecilaColor && NailsBtn.backgroundColor != BeutySpecilaColor && TanningBtn.backgroundColor != BeutySpecilaColor && DogGrommingBtn.backgroundColor != BeutySpecilaColor{
          alert(message: "Select any service which you'd like to receive")
        }
        else if EnterDistanceText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
         alert(message: "Plase enter the distance")
        }
        else if ZipText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            alert(message: "Plase enter the zip code")
        }
        else{
           
            uiBusy.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
//            self.deleteSettingRefrence {
//                print("Deleted..1")
//            }
                let par: [String: AnyObject] = [
                    "Distance": self.EnterDistanceText.text as AnyObject , "Notification": self.Notification  as AnyObject , "Services": self.Services as AnyObject , "Zip": self.ZipText.text as AnyObject,
                    ]
            db = Firestore.firestore()
            let dealsRef = db.collection("Settings").document(String(describing: Auth.auth().currentUser!.uid))
            dealsRef.setData(par)
//            self.cancel()
            uiBusy.stopAnimating()
            self.loadTable()
//                self.functions.httpsCallable("chnageSettings").call(par) { _, _ in
//                    // Ignore errors for now
//                     print("Added")
//                    self.cancel()
//                    uiBusy.stopAnimating()
//                    return
//                }
//            }

            
                    
                
            
        
        }
       
    }
    func SetServices(Services:[String]){
        for service in Services{
            print(service)
            switch service{
            case "Hair":
                HairBtn.setImage(UIImage(named: "hair"), for: .normal)
                HairBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Hair")
            case "Spa":
                SpaBtn.setImage(UIImage(named: "spa"), for: .normal)
                SpaBtn.backgroundColor = self.BeutySpecilaColor
                 self.Services.appendUniqueObject(object:"spa")
            case "Nails":
                NailsBtn.setImage(UIImage(named: "nailpaint"), for: .normal)
                NailsBtn.backgroundColor = self.BeutySpecilaColor
                 self.Services.appendUniqueObject(object:"Nails")
            case "Tanning":
                TanningBtn.setImage(UIImage(named: "tanning"), for: .normal)
                TanningBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Tanning")
            case "Dog Grooming":
                DogGrommingBtn.setImage(UIImage(named: "Dog"), for: .normal)
                DogGrommingBtn.backgroundColor = self.BeutySpecilaColor
                 self.Services.appendUniqueObject(object:"Dog Grooming")
            case "Skin Care":
                SkinCareBtn.setImage(UIImage(named: "Skin"), for: .normal)
                SkinCareBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Skin Care")
            case "Wax":
                WaxBtn.setImage(UIImage(named: "wax"), for: .normal)
                WaxBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Wax")
            case "Eyelash":
                EyelashBtn.setImage(UIImage(named: "eyelash"), for: .normal)
                EyelashBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Eyelash")
            case "Eyebrow":
                EyebrowBrn.setImage(UIImage(named: "Eyebrow"), for: .normal)
                EyebrowBrn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Eyebrow")
            case "Make Up":
                MakeupBtn.setImage(UIImage(named: "make_up"), for: .normal)
                MakeupBtn.backgroundColor = self.BeutySpecilaColor
                self.Services.appendUniqueObject(object:"Make Up")
                
            default:
                 print("Default")
            }
        }
        
    }
    @IBAction func ScrollRightButtonAction(_ sender: Any) {
        self.ScrollView.scrollTo(direction: .Right, animated: true)

    }
    @IBAction func ScrollLeftButtonAction(_ sender: Any) {
       self.ScrollView.scrollTo(direction: .Left, animated: true)
    }
    
    @IBAction func DistancePickerButton(_ sender: UIButton) {
        AddDistanceToArray()
        CreatePricePIcker()
    }
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.ScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.ScrollView.scrollRectToVisible(frame, animated: animated)
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
    
   
        @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
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
                        self.ZipCode = pm.postalCode ?? "nil"
                    }
                    if pm.country != nil {
                        //                        addressString = addressString + pm.country! + ", "
                    }
                    
                    self.ZipText.text =  addressString
                    print(addressString)
                }
        })
        
    }
}
extension UIScrollView {
    enum ScrollDirection {
        case Top
        case Right
        case Bottom
        case Left
        
        func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
            var contentOffset = CGPoint.zero
            switch self {
            case .Top:
                contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
            case .Right:
                contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
            case .Bottom:
                contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            case .Left:
                contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
            }
            return contentOffset
        }
    }

    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
    
}
