//
//  ScheduleAppontmentController.swift
//  Salon
//
//  Created by Rahul Tiwari on 3/13/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit
import ImageSlideshow
import DateTimePicker
import CoreLocation
import Firebase
import McPicker
class ScheduleAppontmentController:BaseViewController , DateTimePickerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,SelectServiceDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,ZipDelegate{
    
    let BeutySpecilaColor = UIColor(r:85,g:211,b:199)
     var ControllerName = String()
    var PriceArray = [String]()
     var MilesAwayArray = [String]()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
     lazy var functions = Functions.functions()
    var Services = [String]()
    @IBOutlet weak var ImageSlideShow: ImageSlideshow!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var ServiceLbl: UILabel!
    @IBOutlet weak var ZipTextField: UITextField!
    @IBOutlet weak var BookPayBtn: UIButton!
    @IBOutlet weak var DateDropDown: UIButton!
    @IBOutlet weak var TimeDropDown: UIButton!
    @IBOutlet weak var ServiceDropDown: UIButton!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var PriceDropDownBTn: UIButton!
    @IBOutlet weak var MilesAwaylbl: UILabel!
    @IBOutlet weak var StackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var PriceText: UITextField!
    @IBOutlet weak var PriceBar: UISlider!
    @IBOutlet weak var MilesAwayView: CardView!
    @IBOutlet weak var ZipOrCityView: CardView!
    @IBOutlet weak var EndiTimeLabel: UILabel!
    var UserName = ""
    //MARK:- Card Views
    
    var ZipCode = ""
    var Locality = ""
    var DateActive = 0
     var EndTimeActive = false
    
   let localSource = [ImageSource(imageString: "Image_dryer")!, ImageSource(imageString: "Image_lip")!, ImageSource(imageString: "WaxingImage")!,  ImageSource(imageString: "Hair - Beauty shot 1 for")!,ImageSource(imageString: "DogImage")! ,ImageSource(imageString: "FacialImage")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        //21.228124
        //72.833770
        ImageSlideShow.draggingEnabled = false
        if ControllerName == "View Deals"{
            self.MilesAwayView.isHidden = true
            self.ZipOrCityView.isHidden = true
            let newMultiplier:CGFloat = 0.25
            StackViewHeightConstraint = StackViewHeightConstraint.setMultiplier(multiplier: newMultiplier)
            self.ZipTextField.text = "nil"
            self.MilesAwaylbl.text = "nil"
        }
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
     
        
//        let ScrollView = ScrollViewController()
//        ScrollView.contentView = self.view
        self.navigationController?.navigationBar.prefersLargeTitles = false
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        setupKeyboardObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let SelectServices = SelectServicesVC()
        SelectServices.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                self.view.frame.origin.y = ((self.view.frame.height - (self.BookPayBtn.frame.maxY + 12 + keyboardHeight)) > -100) && ((self.view.frame.height - (self.BookPayBtn.frame.maxY + 12 + keyboardHeight)) < 0) ? (self.view.frame.height - (self.BookPayBtn.frame.maxY + 12 + keyboardHeight)) : -200
            } else {
                self.view.frame.origin.y = -200
            }
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    @objc func resignKeyboard() {
        ZipTextField.resignFirstResponder()
        
    }
    @IBAction func PriceBarAction(_ sender: UISlider) {
       
        self.PriceLbl.text = String(format: "%i",Int(sender.value))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func BookPayAction(_ sender: Any) {
        handleCreate()
        
    }
    @IBAction func DatePickerButton(_ sender: UIButton) {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 365)

        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
        picker.isDatePickerOnly = true
         picker.doneBackgroundColor = self.BeutySpecilaColor
        picker.dateFormat = "MM/dd/yyyy"
        picker.includeMonth = true
//        picker.in
         picker.delegate = self
        DateActive = 1
        DateLbl.becomeFirstResponder()
//         picker.donePicking()
        picker.show()
//        self.view.addSubview(picker)
        
    }
    @IBAction func EndTimePickerButton(_ sender: Any) {
        
        // Create a DatePickerlet min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
        picker.is12HourFormat = true
        picker.dateFormat  = "h:mm a"
        picker.isTimePickerOnly = true
        picker.doneBackgroundColor = self.BeutySpecilaColor
        picker.timeInterval = DateTimePicker.MinuteInterval.init(rawValue: 10)!
        picker.delegate = self
        DateActive = 3
        TimeLbl.becomeFirstResponder()
        //        picker.donePicking()
        //        self.view.addSubview(picker)
        picker.show()
    }
    
    @IBAction func TimePickerButton(_ sender: UIButton) {
        
        // Create a DatePickerlet min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
         let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
        picker.is12HourFormat = true
        picker.dateFormat  = "h:mm a"
        picker.isTimePickerOnly = true
        picker.doneBackgroundColor = self.BeutySpecilaColor
        picker.timeInterval = DateTimePicker.MinuteInterval.init(rawValue: 10)!
         picker.delegate = self
        DateActive = 2
         TimeLbl.becomeFirstResponder()
//        picker.donePicking()
//        self.view.addSubview(picker)
        picker.show()
    }
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        let Date = picker.selectedDateString
        
            if DateActive == 1{
                self.DateLbl.text = Date
            }
            else if  DateActive == 2 {
                self.TimeLbl.text = Date
            } else if DateActive == 3{
                self.EndiTimeLabel.text = Date
        }

            
        
      
       
       
        
    }
    @IBAction func ServiceButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectServicesVC") as! SelectServicesVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
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
                           self.Locality = pm.subLocality ?? "nil"
                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                         self.Locality.append(", "+pm.locality!)
                    }
                   
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                         self.ZipCode = pm.postalCode ?? "nil"
                    }
                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
                    }
                    
                   self.ZipTextField.text =  addressString
                    print(addressString)
                }
        })
        
    }
    
    //Create
    @objc func handleCreate() {
        if DateLbl.text != "Date" && TimeLbl.text != "Time" && ServiceLbl.text != "Service" && PriceLbl.text != "Price" && MilesAwaylbl.text != "Miles Away" && ZipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
         let style = self.ZipTextField.text
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        
        let par: [String: AnyObject] = [
            "Date": DateLbl.text as AnyObject , "Time": TimeLbl.text as AnyObject , "Services": Services as AnyObject ,"Price":PriceLbl.text as AnyObject,"MilesAway":MilesAwaylbl.text as AnyObject , "Zip": style as AnyObject, "Name": UserName as AnyObject,
            ]
//        functions.httpsCallable("makeReservation").call(par) { (_, error) in
//            if Error.self != Error.self{
//                  uiBusy.stopAnimating()
//                self.cancel()
//                return
//
//            }
//            else{
//                  uiBusy.stopAnimating()
//                print("Error.........",Error.self)
//            }
//        }
        
        functions.httpsCallable("makeReservation").call(par) { _, _ in
            // Ignore errors for now
             uiBusy.stopAnimating()
           
            self.presentAlertWithTitle(title: "Alert", message: "Your request has been sent to our community of Beauty Professionals. Your respones can be found by clicking on your Matches icon after they make you an offer.", options: "Got it, thanks!") { (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                     self.cancel()
                    print("option one")
                    break
                case 1:
                    print("option two")
                default:
                    break
                }
            }
//            self.alert(message: "Your Request has been submitted and watch out for bids in your inbox")
           
            
            return
        }
        }
        else{
            if DateLbl.text == "Date"{
                
                alert(message: "Please choose a date")
            }
            else if TimeLbl.text == "Time"{
                
             alert(message: "Please choose a time")
            }
            else if ServiceLbl.text == "Service"{
                
                 alert(message: "Please select atleast one service")
            }
            else if PriceLbl.text == "Price"{
                
                alert(message: "Please select a price")
            }
            else if MilesAwaylbl.text == "Miles Away"{
                
                alert(message: "Please select  Miles")
            }
            else if ZipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                
                 alert(message: "Please enter the zip code")
            }
            else {
                alert(message: "Please fill all the details")
            }
        }
    }
    @IBAction func MilesAwayBtnAction(_ sender: Any) {
        AddPriceToArray(Count: 26)
        CreatePricePIcker(Price: false)
        
    }
    
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Select Service Delegate
    func ServicesList(Services: Array<String>) {
        self.Services = Services
        print("ServiceSList",Services)
        self.ServiceLbl.text = Services.joined(separator: ",")
//        for Service in Services{
////            self.ServiceLbl.text = Service + ","
//            self.ServiceLbl.text?.append(Service + ",")
//        }
    
    }
    func AddPriceToArray(Count:Int){
        for  i in (0..<Count){
            if Count == 2501{
            PriceArray.append("$"+"\(i*10)")
            }
            else{
                if  i == 1{
                     MilesAwayArray.append("\(i)"+"  Mile Away")
                }
                else{
                     MilesAwayArray.append("\(i)"+"  Miles Away")
                }
               
            }
        }
    }
    @IBAction func PriceDropDownAction(_ sender: UIButton) {
      
        AddPriceToArray(Count: 2501)
         CreatePricePIcker(Price: true)
        
    }
    
    func CreatePricePIcker(Price:Bool){
        let data: [[String]] = [
            ["Sir", "Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]
        var MCPicker = McPicker()
        if Price{
         MCPicker = McPicker(data: [PriceArray])
        }
        else{
              MCPicker = McPicker(data: [MilesAwayArray])
        }
        
        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = .white
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!
        MCPicker.label = customLabel // Set your custom label
        
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: MCPicker, title: "Select") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: MCPicker, barButtonSystemItem: .cancel) // or system items
        MCPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        
        MCPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!
        
        MCPicker.toolbarButtonsColor = .white
        MCPicker.toolbarBarTintColor = UIColor(r:85,g:211,b:199)
        MCPicker.pickerBackgroundColor = UIColor(r:85,g:211,b:199)
        MCPicker.backgroundColor = UIColor.clear
        MCPicker.backgroundColorAlpha = 0.50
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
            MCPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                if let prefix = selections[0] {
                    if Price{
                         self?.PriceLbl.text =  prefix
                    }
                    else{
                          self?.MilesAwaylbl.text =  prefix
                    }
                }
                }, cancelHandler: {
                    print("Canceled Styled Picker")
            }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
                let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
                print("Component \(componentThatChanged) changed value to \(newSelection)")
            })
        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PriceArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "$"+"\(PriceArray[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(PriceArray[row])
        self.PriceLbl.text = "$"+"\(PriceArray[row])"
        self.view.endEditing(true)
        
    }
    
    //TextFeiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin...")
       
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
        switch (buttonIndex){
            
        case 0:
            print("Cancel")
        case 1:
            self.ZipTextField.text = ZipCode
            print("ZipCode")
        case 2:
                self.ZipTextField.text = Locality
            print("Locality")
        case 3:
            print("Other")
        default:
            print("Default")
            //Some code here..
            
        }
    }
    //Zip Delegate
    func LocationOrzip(Zip: String) {
        ZipTextField.text = Zip
    }
    
    @IBAction func ZipDistanceBtnAction(_ sender: Any) {
//        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ZipCode,Locality)
//
//        actionSheet.show(in: self.view)
//        print("actionsheet")
        let SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
         SearchViewController.Delegate = self
         SearchViewController.SearchText = self.ZipCode
        self.present(SearchViewController, animated: true, completion: nil)
    }
    
}

