//
//  AppDelegate.swift
//  Hinario
//
//  Created by Ewerson Castelo on 06/12/2017.
//  Copyright © 2017 Ewerson Castelo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import CoreData
import SystemConfiguration
import GoogleMobileAds
import Reachability

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes


class CustomNavigationController: UINavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
  var window: UIWindow?
	
//	let reachability = Reachability()
	let reachability = try? Reachability()
	

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		//Ativar Recursos Offline
		Database.database().isPersistenceEnabled = true
		
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = UIColor(red: 30/255, green: 68/255, blue: 76/255, alpha: 1)
	
		if #available(iOS 11.0, *) {
			UINavigationBar.appearance().prefersLargeTitles = true
			UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.verdeTitulo]
			UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.verdeTitulo]
		} else {
			// Fallback on earlier versions
		}
		
		window = UIWindow()
		window?.makeKeyAndVisible()
		
		//start for Hinos Controller Page
		let hinosController = HinosController()
		let navController = CustomNavigationController(rootViewController: hinosController)
		window?.rootViewController = navController
		
		reachability?.whenReachable = { reachability in
			if reachability.connection == .wifi {
				print("Reachable via WiFi")
			} else {
				print("Reachable via Cellular")
			}
		}
		reachability?.whenUnreachable = { _ in
			print("Not reachable")
		}
		
		do {
			try reachability?.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
    
    MSAppCenter.start("9a24c3ed-0628-4037-a909-1fe4b1447f04", withServices:[
      MSAnalytics.self,
      MSCrashes.self
    ])
    
    
    return true
  }
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
		
		return handled
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
			reachability?.stopNotifier()
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		reachability?.stopNotifier()
	}
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return .portrait
  }

}

