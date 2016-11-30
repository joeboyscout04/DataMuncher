//
//  AppDelegate.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataStack: CoreDataManager?
    
    let appColor = UIColor(red: 73.0/255.0, green: 142.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataStack = CoreDataManager(callback: { (error) in
            
            if(error == nil){
                self.dataStack?.loadData()
            }
        })
        
        //set up theming
        //Navbar skinning
        let navbarSkin = UINavigationBar.appearance()
        navbarSkin.barTintColor = self.appColor
        
        navbarSkin.tintColor = UIColor.white
        
        let navBarFont = UIFont(name:"GillSans", size:18);
        let textTitleOptions = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:navBarFont]
        
        navbarSkin.titleTextAttributes = textTitleOptions
        
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
        do{
           try dataStack?.managedObjectContext.save()
        }
        catch {
            NSLog("AppDelegate:applicationWillTerminate: error saving data to CoreData!")
        }
    }

}

