//
//  RegViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 1/29/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import UITextField_Shake
import FirebaseFirestore

class RegViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var LastnameTextfeild: LoginTextField!
    @IBOutlet weak var nameTextField: LoginTextField!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var repeatTextField: LoginTextField!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var registerButton: LoadingButton!
    @IBOutlet weak var containerView: UIView!
    lazy var functions = Functions.functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = #imageLiteral(resourceName: "Back")
        view.insertSubview(backgroundImageView, at: 0)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
        userIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupKeyboardObservers()
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
                
                self.view.frame.origin.y = ((self.view.frame.height - (self.registerButton.frame.maxY + 12 + keyboardHeight)) > -100) && ((self.view.frame.height - (self.registerButton.frame.maxY + 12 + keyboardHeight)) < 0) ? (self.view.frame.height - (self.registerButton.frame.maxY + 12 + keyboardHeight)) : -200
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
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatTextField.resignFirstResponder()
    }

    @objc func handleRegister() {
        resignKeyboard()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text,let lastname = LastnameTextfeild.text,  let repeatPassword = repeatTextField.text
            else {
                fatalError("textfield is nil")
        }
        
        if repeatPassword != password {
            self.passwordTextField.shake(2, withDelta: 4, speed: 0.07)
            self.repeatTextField.shake(2, withDelta: 4, speed: 0.07)
            self.repeatTextField.text = ""
            self.passwordTextField.text = ""
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Please double check your password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.emailTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.repeatTextField.text = ""
                        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "🌚 Email address is invalid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    case .emailAlreadyInUse:
                        self.emailTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.repeatTextField.text = ""
                        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "🌚 Account has existed", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    case .weakPassword:
                        self.passwordTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.passwordTextField.text = ""
                        self.repeatTextField.text = ""
                        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "🌚 Your password is too weak", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    default:
                        self.emailTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.passwordTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.repeatTextField.text = ""
                    }
                }
                return
            }
            
            let values: [String: AnyObject] = ["name": name + " " + lastname as AnyObject,"Type":"Salon" as AnyObject]
            self.functions.httpsCallable("createUser").call(values) { (result, err) in
                guard err == nil else {
                    print(err!)
                    return
                }
                print("User created")
            }
            
            
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let profileImage = self.userIcon.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                // change to JPEG for better compression, current resolution: 0.1
                storageRef.putData(uploadData, metadata: nil, completion: { metadata, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    var db = Firestore.firestore()
                    let dealsRef = db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
                    dealsRef.updateData(["icon": imageName as Any])
                })
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCreate(_ sender: Any) {
        handleRegister()
    }
}

extension RegViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatTextField.becomeFirstResponder()
        } else if textField == repeatTextField {
            handleRegister()
        }
        return false
    }
}

extension RegViewController: UIImagePickerControllerDelegate {
    @objc func handleSelectProfileImageView() {
        print("lhylhy")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            userIcon.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
