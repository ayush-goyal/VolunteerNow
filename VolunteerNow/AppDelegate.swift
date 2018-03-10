//
//  AppDelegate.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/6/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setAppearance()
        
        FirebaseApp.configure()
        App.shared.dbRef = Database.database().reference()

        setupNotifications(application)
        setupAuthentication()
        
        // Reset Organization Code
        //let defaults = UserDefaults.standard
        //defaults.set("", forKey: "organizationCode")
        
        return true
    }
    
    private func setAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.Custom.purple,
            NSAttributedStringKey.font: UIFont(name: "SofiaPro-Medium", size: 20)!
        ]
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UITabBar.appearance().tintColor = UIColor.Custom.purple
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
    
    private func setupNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        App.User.fcmToken = Messaging.messaging().fcmToken
    }
    
    private func setupAuthentication() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Check to see if user is signed in
        
        if Auth.auth().currentUser == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signInController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        } else {
            print("User is logged into firebase")
            
            if let displayName = Auth.auth().currentUser?.displayName, let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
                App.User.uid = uid
                App.User.name = displayName
                App.User.email = email
            } else {
                Popup.presentError(text: "User name, id, or email not set", viewController: nil, appDelegateWindow: self.window)
            }
        }
    }
    
}


extension AppDelegate: GIDSignInDelegate {
    // MARK: - Firebase Sign In
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        if let error = error {
            Popup.presentError(text: error.localizedDescription, viewController: nil, appDelegateWindow: window)
        }
        
        guard let authentication = user?.authentication else {
            Popup.presentError(text: "Failed to sign in", viewController: nil, appDelegateWindow: window)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                Popup.presentError(text: error.localizedDescription, viewController: nil, appDelegateWindow: self.window)
            }
            // User is signed in
   
            if let displayName = user?.displayName, let uid = user?.uid, let email = user?.email {
                App.User.uid = uid
                App.User.name = displayName
                App.User.email = email
                
                App.shared.dbRef.child("users/\(uid)/name").setValue(displayName)
            } else {
                Popup.presentError(text: "User name, id, or email not set", viewController: nil, appDelegateWindow: self.window)
            }
            print("User successfully signed into firebase")
            let navigationController = self.window?.rootViewController as? UINavigationController
            navigationController?.topViewController?.performSegue(withIdentifier: "homeViewSegue", sender: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        Popup.presentError(text: error.localizedDescription, viewController: nil, appDelegateWindow: window)
    }

}



extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // MARK: - Firebase Messaging
    
    // If registration token is refreshed, update FCM token global variable
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token: \(fcmToken)")
        App.User.fcmToken = fcmToken
    }
    
}
