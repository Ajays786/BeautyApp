//
//  ViewController.swift
//  demo design
//
//  Created by Jayesh Kumar on 3/27/19.
//  Copyright © 2019 Jayesh Kumar. All rights reserved.
//

import UIKit

protocol SelectServiceDelegate {
    func ServicesList(Services:Array<String>)
}

class SelectServicesVC: BaseViewController {

    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var view_hair: UIView!
    @IBOutlet weak var view_nails: UIView!
    @IBOutlet weak var view_eyebrows: UIView!
    @IBOutlet weak var view_eyelash: UIView!
    @IBOutlet weak var view_makeup: UIView!
    @IBOutlet weak var view_massage: UIView!
    @IBOutlet weak var view_tanning: UIView!
    @IBOutlet weak var view_wax: UIView!
    @IBOutlet weak var view_dog: UIView!
    @IBOutlet weak var view_skin: UIView!
    
    @IBOutlet weak var btn_hairView_toggle: UIButton!
    @IBOutlet weak var btn_nailsView_toggle: UIButton!
    @IBOutlet weak var btn_eyebrowsView_toggle: UIButton!
    @IBOutlet weak var btn_eyelashView_toggle: UIButton!
    @IBOutlet weak var btn_makeupView_toggle: UIButton!
    @IBOutlet weak var btn_massageView_toggle: UIButton!
    @IBOutlet weak var btn_tanningView_toggle: UIButton!
    @IBOutlet weak var btn_waxView_toggle: UIButton!
    @IBOutlet weak var btn_skincareView_toggle: UIButton!
    @IBOutlet weak var btn_dogCareView_toggle: UIButton!
    
    
    @IBOutlet weak var hair_arrow_imageView: UIImageView!
    @IBOutlet weak var nails_arrow_imageView: UIImageView!
    @IBOutlet weak var skin_arrow_imageview: UIImageView!
    @IBOutlet weak var Dog_arrow_imageview: UIImageView!
    
    @IBOutlet weak var eyebrow_arrow_imageView: UIImageView!
    @IBOutlet weak var eyelash_arrow_imageView: UIImageView!
    @IBOutlet weak var makeup_arrow_imageView: UIImageView!
    @IBOutlet weak var massage_arrow_imageView: UIImageView!
    @IBOutlet weak var tanning_arrow_imageView: UIImageView!
    @IBOutlet weak var wax_arrow_imageView: UIImageView!
    
    var ServicesList = [String]()
     var delegate:SelectServiceDelegate?
    @IBOutlet weak var hairView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var nailsView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var eyebrowsView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var eyelashView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var makeupView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var massageView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var tanningView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var waxView_height_constraints: NSLayoutConstraint!
    @IBOutlet weak var DogView_height_Constraints: NSLayoutConstraint!
    @IBOutlet weak var SkinView_height_Constraints: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.backgroundColor = UIColor(r: 85, g: 211, b: 199)
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SelectServicesVC.back(sender:)))
//        self.navigationItem.leftBarButtonItem = newBackButton

        //hair
        hair_arrow_imageView.image = UIImage(named: "dropdown")
        view_hair.isHidden = true
        hairView_height_constraints.constant = 90
        
        //nails
        nails_arrow_imageView.image = UIImage(named: "dropdown")
        view_nails.isHidden = true
        nailsView_height_constraints.constant = 90
        
        //eyebrows
        eyebrow_arrow_imageView.image = UIImage(named: "dropdown")
        view_eyebrows.isHidden = true
        eyebrowsView_height_constraints.constant = 90
        
        //eyelash
        eyelash_arrow_imageView.image = UIImage(named: "dropdown")
        view_eyelash.isHidden = true
        eyelashView_height_constraints.constant = 90
        
        //makeup
        makeup_arrow_imageView.image = UIImage(named: "dropdown")
        view_makeup.isHidden = true
        makeupView_height_constraints.constant = 90
        
        //massage
        massage_arrow_imageView.image = UIImage(named: "dropdown")
        view_massage.isHidden = true
        massageView_height_constraints.constant = 90
        
        //tanning
        tanning_arrow_imageView.image = UIImage(named: "dropdown")
        view_tanning.isHidden = true
        tanningView_height_constraints.constant = 90
        
        //wax
        wax_arrow_imageView.image = UIImage(named: "dropdown")
        view_wax.isHidden = true
        waxView_height_constraints.constant = 90
        
        
        //Dog
        Dog_arrow_imageview.image = UIImage(named: "dropdown")
        view_dog.isHidden = true
        DogView_height_Constraints.constant = 90
        
        
        //Skin
        skin_arrow_imageview.image = UIImage(named: "dropdown")
        view_skin.isHidden = true
        SkinView_height_Constraints.constant = 90
    }

    @IBAction func btn_hairView_pressed(_ sender: Any) {
        if hair_arrow_imageView.image == UIImage(named: "up-arrow") {
            hair_arrow_imageView.image = UIImage(named: "dropdown")
            view_hair.isHidden = true
            hairView_height_constraints.constant = 90
            view_hair.layoutIfNeeded()
        }
        else
        {
            hair_arrow_imageView.image = UIImage(named: "up-arrow")
            view_hair.isHidden = false
            hairView_height_constraints.constant = 400
            view_hair.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_nailsView_pressed(_ sender: Any) {
        if nails_arrow_imageView.image == UIImage(named: "up-arrow") {
            nails_arrow_imageView.image = UIImage(named: "dropdown")
            view_nails.isHidden = true
            nailsView_height_constraints.constant = 90
            view_nails.layoutIfNeeded()
        }
        else
        {
            nails_arrow_imageView.image = UIImage(named: "up-arrow")
            view_nails.isHidden = false
            nailsView_height_constraints.constant = 190
            view_nails.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_eyebrowsView_pressed(_ sender: Any) {
        if eyebrow_arrow_imageView.image == UIImage(named: "up-arrow") {
            eyebrow_arrow_imageView.image = UIImage(named: "dropdown")
            view_eyebrows.isHidden = true
            eyebrowsView_height_constraints.constant = 90
            view_eyebrows.layoutIfNeeded()
        }
        else
        {
            eyebrow_arrow_imageView.image = UIImage(named: "up-arrow")
            view_eyebrows.isHidden = false
            eyebrowsView_height_constraints.constant = 225
            view_eyebrows.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_eyelashView_pressed(_ sender: Any) {
        if eyelash_arrow_imageView.image == UIImage(named: "up-arrow") {
            eyelash_arrow_imageView.image = UIImage(named: "dropdown")
            view_eyelash.isHidden = true
            eyelashView_height_constraints.constant = 90
            view_eyelash.layoutIfNeeded()
        }
        else
        {
            eyelash_arrow_imageView.image = UIImage(named: "up-arrow")
            view_eyelash.isHidden = false
            eyelashView_height_constraints.constant = 190
            view_eyelash.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_makeupView_pressed(_ sender: Any) {
        if makeup_arrow_imageView.image == UIImage(named: "up-arrow") {
            makeup_arrow_imageView.image = UIImage(named: "dropdown")
            view_makeup.isHidden = true
            makeupView_height_constraints.constant = 90
            view_makeup.layoutIfNeeded()
        }
        else
        {
            makeup_arrow_imageView.image = UIImage(named: "up-arrow")
            view_makeup.isHidden = false
            makeupView_height_constraints.constant = 190
            view_makeup.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_massageView_pressed(_ sender: Any) {
        if massage_arrow_imageView.image == UIImage(named: "up-arrow") {
            massage_arrow_imageView.image = UIImage(named: "dropdown")
            view_massage.isHidden = true
            massageView_height_constraints.constant = 90
            view_massage.layoutIfNeeded()
        }
        else
        {
            massage_arrow_imageView.image = UIImage(named: "up-arrow")
            view_massage.isHidden = false
            massageView_height_constraints.constant = 225
            view_massage.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_tanningView_pressed(_ sender: Any) {
        if tanning_arrow_imageView.image == UIImage(named: "up-arrow") {
            tanning_arrow_imageView.image = UIImage(named: "dropdown")
            view_tanning.isHidden = true
            tanningView_height_constraints.constant = 90
            view_tanning.layoutIfNeeded()
        }
        else
        {
            tanning_arrow_imageView.image = UIImage(named: "up-arrow")
            view_tanning.isHidden = false
            tanningView_height_constraints.constant = 155
            view_tanning.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_waxView_pressed(_ sender: Any) {
        if wax_arrow_imageView.image == UIImage(named: "up-arrow") {
            wax_arrow_imageView.image = UIImage(named: "dropdown")
            view_wax.isHidden = true
            waxView_height_constraints.constant = 90
            view_wax.layoutIfNeeded()
        }
        else
        {
            wax_arrow_imageView.image = UIImage(named: "up-arrow")
            view_wax.isHidden = false
            waxView_height_constraints.constant = 225
            view_wax.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_DogView_pressed(_ sender: Any) {
        if Dog_arrow_imageview.image == UIImage(named: "up-arrow") {
            Dog_arrow_imageview.image = UIImage(named: "dropdown")
            view_dog.isHidden = true
            DogView_height_Constraints.constant = 90
            view_dog.layoutIfNeeded()
        }
        else
        {
            Dog_arrow_imageview.image = UIImage(named: "up-arrow")
            view_dog.isHidden = false
            DogView_height_Constraints.constant = 190
            view_dog.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_SkinView_pressed(_ sender: Any) {
        if skin_arrow_imageview.image == UIImage(named: "up-arrow") {
            skin_arrow_imageview.image = UIImage(named: "dropdown")
            view_skin.isHidden = true
            SkinView_height_Constraints.constant = 90
            view_skin.layoutIfNeeded()
        }
        else
        {
            skin_arrow_imageview.image = UIImage(named: "up-arrow")
            view_skin.isHidden = false
            SkinView_height_Constraints.constant = 225
            view_skin.layoutIfNeeded()
        }
    }
    
    // All Services Actions
    @IBAction func HairServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Hair(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
            self.ServicesList.append(serv)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
      
    }
    @IBAction func NailsServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Nail(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
             self.ServicesList.append(serv)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
       
    }
    @IBAction func EyebrowsServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.EyeBrow(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(serv)
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
             sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
       
        
    }
    @IBAction func EyelashServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.EyeLash(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(serv)
            
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
       
        
    }
    @IBAction func MakeUpServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.MakeUp(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(serv)
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
        
        
    }
    @IBAction func MassagespaServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.MassageSpa(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(serv)
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
       
        
    }
    @IBAction func TanningServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Tanning(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(serv)
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
             self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
        
        
        
    }
    @IBAction func WaxServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Wax(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
             self.ServicesList.append(Services.Shared.Wax(Index: sender.tag))
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
            self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
        
        
    }
    
    @IBAction func DogServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Dog(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
            self.ServicesList.append(Services.Shared.Dog(Index: sender.tag))
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
            self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
        
        
    }
    
    @IBAction func SkinServicesAction(_ sender: UIButton) {
        let serv =  Services.Shared.Skin(Index: sender.tag)
        print(serv)
        if sender.currentImage == #imageLiteral(resourceName: "check_icon"){
            self.ServicesList.append(Services.Shared.Skin(Index: sender.tag))
            sender.setImage(#imageLiteral(resourceName: "checked_icon"), for: .normal)
        }
        else if sender.currentImage == #imageLiteral(resourceName: "checked_icon"){
            sender.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
            self.ServicesList.index(of:serv).map{self.ServicesList.remove(at: $0)}
        }
        
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
         delegate?.ServicesList(Services: ServicesList)
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitAction(_ sender: UIButton) {
        delegate?.ServicesList(Services: ServicesList)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?)
    {
        super.willMove(toParentViewController: parent)
        if parent == nil
        {
            delegate?.ServicesList(Services: ServicesList)
        }
    }
    
    
}

