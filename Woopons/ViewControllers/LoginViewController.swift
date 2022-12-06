//
//  LoginViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit
import MaterialActivityIndicator

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.forgotButton.underline(color: "primaryRed")
        self.title = "Login"
        self.setBackButtonWithTitle(title: "")
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
        doLogin()
        //        if(usernameTextField.text!.isEmptyOrWhitespace)() {
        //            self.showError(message: "Please enter your username")
        //        }
        //
        //        else if(passwordTextField.text!.isEmptyOrWhitespace()){
        //            self.showError(message: "Please enter your password")
        //        }
        
    }
    
    // MARK: - Api Call's
    
    func doLogin() {
        
        // let parameters: [String: Any] = [ "password": self.passwordTextField.text ?? "" , "email":self.usernameTextField.text ?? "" ]
        
        let parameters: [String: Any] = [ "password": "JSPAZV567" , "email":"rashpal.singh@xcelance.com1","mobile":true ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.login, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            if let dict = response["data"] as? [String:AnyObject] {
                UserDefaults.standard.setValue(dict["token"], forKey: "accessToken")
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}

