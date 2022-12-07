//
//  AppDelegate.swift
//  Woopons
//
//  Created by Harshit Thakur on 20/11/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        setNavigationBarColor()
        if UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool ==  true {
            self.moveToHome()
        }
        else {
            moveToLogin()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func setNavigationBarColor(){
        UIApplication.shared.statusBarStyle = .lightContent
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "primaryRed")
        navBarAppearance.shadowImage = nil // line
        navBarAppearance.shadowColor = UIColor(named: "primaryRed")
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navBarAppearance.titleTextAttributes = textAttributes
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
    }

    func moveToHome(){
        
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        let navigationController = UINavigationController()
       viewController.selectedIndex = 0
        navigationController.navigationItem.setHidesBackButton(true, animated: true)
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func moveToLogin(){
        
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController()
        navigationController.navigationItem.setHidesBackButton(true, animated: true)
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
}

