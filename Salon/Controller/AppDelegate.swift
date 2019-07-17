//
//  AppDelegate.swift
//  Salon
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 Hengyu Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Stripe
import UserNotifications
import FBSDKLoginKit
import GoogleSignIn



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate{
    
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_GaYjqkBZ7FPR7BoF43GeOa9Z"
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.liuhengyu.salon"
        //Facebook Login
         FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Google Sign-In
        GIDSignIn.sharedInstance().clientID = "280545181435-jrv3q8hg7hdrpg1dq6ev2snj8717acc2.apps.googleusercontent.com"
     
        
        UIApplication.shared.statusBarStyle = .lightContent
//        self.window?.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Back"))
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        //
//        do {
//            if let uid = Auth.auth().currentUser?.uid {
////            Database.database().reference().child("users").child(uid).child("token").removeValue()
//                print("Deleted user past token")
//            } else {
//                print("No user token have to be deleted")
//            }
//            try Auth.auth().signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//
//        //        let loginController = LoginViewController()
//
//        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        let navigationController = application.windows[0].rootViewController as! UINavigationController
//        navigationController.pushViewController(loginController, animated: true)
//        //        navController.navigationBar.barStyle = .blackTranslucent
//        //        present(navController, animated: true)
//        //
        
        postToken()
       
        return true
    }
  
    private func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let Facebook: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let Google = GIDSignIn.sharedInstance().handle(url,
                                                       sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                       annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return Facebook || Google
    }
    
    func registerRemoteNotification(_ application: UIApplication) {
        // Configure Firebase Cloud Message
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        let notificationOptions: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: notificationOptions) { _, err in
            debugPrint(err ?? "")
        }
        application.registerForRemoteNotifications()
    }
    
    func messaging(_: Messaging, didReceiveRegistrationToken _: String) {
        postToken()
    }
    
    func postToken() {
        if let userID = Auth.auth().currentUser?.uid, let token = Messaging.messaging().fcmToken {
            Firestore.firestore().collection("user").document(userID).updateData(["token": token as Any])
        } else {
            debugPrint("[FCM] Cannot post token")
        }
    }
    // [START openurl]
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
//    func uncaughtExceptionHandler(exception: NSException?) {
//        print("Crashed...........................................")
//        if let exception = exception {
//            print("CRASH: \(exception)")
//        }
//        if let call = exception?.callStackSymbols {
//            print("Stack Trace: \(call)")
//        }
//        // Internal error reporting
//    }
  
    func applicationWillEnterForeground(_ application: UIApplication) {
//         AppHelper.selectTabBarIndexTo(index: 3)
    }
    
}
