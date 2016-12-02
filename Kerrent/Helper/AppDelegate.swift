//
//  AppDelegate.swift
//  Kerrent
//
//  Created by Ronald Liew on 28/11/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        observeAuthNotification()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        // Checking point for whether user default is made
//        let userDefaults = UserDefaults.standard
//        if !userDefaults.bool(forKey: "hasLoggedIn"){
//            checkLoadPage(storyboard: "RegisterStoryboard", controllername: "LoginViewController")
//            userDefaults.set(true, forKey: "hasLoggedIn")
//        }
//        else {
//            checkLoadPage(storyboard: "Frontpage", controllername: "FrontPageViewController")
//        }
//
//
//        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
    }
}

extension AppDelegate{
    func observeAuthNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthNotification(_ :)), name: Notification.Name(rawValue:"AuthSuccessNotification"), object: nil)
    }
    
    func handleAuthNotification(_ notification : Notification){
        //this part will only be called if user successfuly logged in
        self.checkLoadPage(storyboard: "Frontpage", controllername: "FrontPageViewController")
    }
    
    func checkLoadPage(storyboard : String, controllername : String){
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: controllername)
        self.window?.rootViewController = controller
    }
}

