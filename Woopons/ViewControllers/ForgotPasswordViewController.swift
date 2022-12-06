//
//  ForgotPasswordViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot Password"
        self.setBackButtonWithTitle(title: "")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.pushToEnterCode()
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        if(emailTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter your email address")
        }
        else {
            forgotPassword()
        }
    }
    
    func forgotPassword() {
        
        let parameters: [String: Any] = ["email":self.emailTextField.text ?? "" ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.forgotPassword, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            if let dict = response["data"] as? [String:AnyObject] {
                self.showError(message: dict["message"] as? String ?? "")
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
