//
//  LoginViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit
import MaterialActivityIndicator

class LoginViewController: UIViewController {
    
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.forgotButton.underline(color: "primaryRed")
        self.title = "Login"
        self.setLeftButnEmpty()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func forgotButtonAction(_ sender: UIButton) {
        self.pushToForgotPassword()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        checkValidations()
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        
        if(usernameTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter email address")
        }
        
       else if !self.isValidEmail(self.usernameTextField.text ?? "") {
            self.showError(message: "Please enter valid email address")
        }
        
        else if(passwordTextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please enter your password")
        }
        else {
            doLogin()
        }
        
    }
    
    func isValidEmail(_ emailString: String) -> Bool {
        let emailRegex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[‌​a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailString)
    }
    
    @IBAction func iconAction(sender: AnyObject) {
        if iconClick {
            passwordTextField.isSecureTextEntry = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    // MARK: - Api Call's
    
    func doLogin() {
        
        let parameters: [String: Any] = [ "password": self.passwordTextField.text ?? "" , "email":self.usernameTextField.text ?? "","mobile":true, "device_id":UIDevice.current.identifierForVendor?.uuidString ?? ""]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.login, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            if let dict = response["data"] as? [String:AnyObject] {
                UserDefaults.standard.setValue(dict["token"], forKey: "accessToken")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                // iOS13 or later
                if #available(iOS 13.0, *) {
                    let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                    sceneDelegate.moveToHome()
                    
                    // iOS12 or earlier
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.moveToHome()
                }
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}

