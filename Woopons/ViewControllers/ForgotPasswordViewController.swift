//
//  ForgotPasswordViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot Password"
        self.setBackButtonWithTitle(title: "")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.checkValidations()
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        if(emailTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter your email address")
        }
        else if !self.isValidEmail(self.emailTextField.text ?? "") {
            self.showError(message: "Please enter valid email address")
        }
        else {
            forgotPassword()
        }
    }
    
    func isValidEmail(_ emailString: String) -> Bool {
        let emailRegex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[‌​a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailString)
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        self.popupView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func forgotPassword() {
        
        let parameters: [String: Any] = ["email":self.emailTextField.text ?? "" ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.forgotPassword, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.alertLabel.text = response["message"] as? String ?? ""
            self.popupView.isHidden = false
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
