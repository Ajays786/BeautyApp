//
//  LogViewController.swift
//  Salon
//
//  Created by 刘恒宇 on 1/21/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit
import UITextField_Shake
import FBSDKLoginKit
import GoogleSignIn
import SwiftyUserDefaults
import SwiftyJSON
import FirebaseFirestore
class LogViewController: BaseViewController, UINavigationControllerDelegate,GIDSignInDelegate , GIDSignInUIDelegate  {
    
    @IBOutlet weak var loginButton: LoadingButton!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    let array =  ["abc"]
      var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
          GIDSignIn.sharedInstance().delegate = self
//        checkIfUserIsLoggedIn()
//        let backgroundImageView = UIImageView(frame: self.view.bounds)
//        backgroundImageView.image = #imageLiteral(resourceName: "Back")
//        view.insertSubview(backgroundImageView, at: 0)
//
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.view.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.loginContainerView.layer.cornerRadius = 5
        self.loginContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard)))
    }
    @IBAction func loginAction(_ sender: Any) {
        handleLogin()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        handleRegister()
    }
    
    
    @IBAction func ForgotPasswordAction(_ sender: Any) {
        handleForgotPassword()
    }
    
    @objc func resignKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleLogin() {
        loginButton.showLoading()
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = usernameTextField.text, let password = passwordTextField.text
            else {
                fatalError("textfield is nil")
        }
        
        if usernameTextField.text == "" {
            usernameTextField.shake(2, withDelta: 4, speed: 0.07)
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "Email cannot be empty", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        }
        
        if passwordTextField.text == "" {
            passwordTextField.shake(2, withDelta: 4, speed: 0.07)
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password cannot be empty", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        }
        
        if (usernameTextField.text == "") || (passwordTextField.text == "") {
            loginButton.hideLoading()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                debugPrint(error)
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.usernameTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "🌚 Email address is invalid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    case .userNotFound:
                        self.usernameTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "🌚 Account doesn't exist", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    case .wrongPassword:
                        self.passwordTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.passwordTextField.text = ""
                        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "🌚 The password is incorrect", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                    default:
                        self.usernameTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.passwordTextField.shake(2, withDelta: 4, speed: 0.07)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                }
                self.loginButton.hideLoading()
               
                return
            }
            self.CheckUser()
            
        }
    }
    
    func CheckUser(){
        db = Firestore.firestore()
        let dealsRef = db.collection("user").document(Auth.auth().currentUser?.uid ?? "")
        dealsRef.addSnapshotListener { (snapshot, error) in
            guard let doc = snapshot, let dic = doc.data() else {
                print(error)
                return
            }
            if let name = dic["Type"] as? String{
                print("Type.....................", name)
                if name == "Salon"{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.registerRemoteNotification(UIApplication.shared)
                    
                    self.dismiss(animated: true, completion: {
                        
                    })
                }
                else{
                    self.alert(message: "User is not registered with this app try login with merchnat")
                    self.loginButton.hideLoading()
                    self.handleLogout()
                }
              
            } else {
                self.alert(message: "User is not registered with this app try login with merchnat")
                 self.loginButton.hideLoading()
                 self.handleLogout()
            }
            //            if let email = Auth.auth().currentUser?.email{
            //                self.emailCell.textLabel?.text = email
            //            } else {
            //                self.emailCell.textLabel?.text = "N/A"
            //            }
        }
    }

    @objc func handleForgotPassword(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot password?", message: "Enter registered email", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter registered email"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
       alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            // Force unwrapping because we know it exists.
            if ((textField?.text?.trimmingCharacters(in: .whitespacesAndNewlines)) != ""){
                Auth.auth().sendPasswordReset(withEmail: (textField?.text)!, completion: { (error) in
                    if error != nil{
                        self.alert(message: error?.localizedDescription ?? "Please eneter a valid email")
                    }
                    else{
                        
                       self.alert(message: "", title: "Password reset link has been sent on your registered email")
                    }
                })
            }
            else{
                self.alert(message: "Please enter your registered email ")
            }
            print("Text field: \(textField?.text)")
            //Send Reset Password Link
//
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @objc func handleRegister() {
//        let registerController = RegisterController()
        let registerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerViewController") as! RegViewController
//        navigationController?.present(registerController, animated: true, completion: nil)
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let maxYButton = loginButton.frame.maxY + loginContainerView.frame.minY + 12
            let maxYKeyboard = SCREEN_HEIGHT - keyboardHeight
            print("lhy \(maxYButton) \(maxYKeyboard)")
            if maxYButton > maxYKeyboard {
                UIView.animate(withDuration: keyboardDuration!, animations: {
                    self.view.frame.origin.y = maxYKeyboard - maxYButton
                })
            }
        } else {
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.frame.origin.y = -100
            })
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func FaceBookLoginButton(_ sender: Any) {//action of the custom button in the storyboard
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let jsonData = try? JSONSerialization.data(withJSONObject:result)
                    do {
                        //here dataResponse received from a network request
                        let decoder = JSONDecoder()
                        let FBmodel = try decoder.decode(KFacebookModel.self, from:
                            jsonData!) //Decode JSON Response Data
                        print(FBmodel)
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                 
                    //everything works print the user data
                    print(result)
                    // push view to main
                }
            })
        }
    }
    @IBAction func GoogleLoginButton(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
}

extension LogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            handleLogin()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            usernameTextField.placeholder = "Username"
        } else if textField == passwordTextField {
            passwordTextField.placeholder = "Password"
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            // add delay to solve the warning message "Unbalanced calls to begin"
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            // Ask for registor remote notificatio
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
        
        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        let navController = UINavigationController(rootViewController: loginController)
        self.navigationController?.pushViewController(loginController, animated: true)
//        navController.navigationBar.barStyle = .blackTranslucent
//        present(navController, animated: true)
    }
}
