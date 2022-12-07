//
//  LogoutViewController.swift
//  Woopons
//
//  Created by harsh on 22/11/22.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        // iOS13 or later
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.moveToLogin()

        // iOS12 or earlier
        } else {
            // UIApplication.shared.keyWindow?.rootViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.moveToLogin()
        }
    }
}
