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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set fonts
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
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        App.shared.dbRef = Database.database().reference()
        
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
        
        // Reset Organization Code
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "organizationCode")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Firebase
    
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VolunteerNow")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

