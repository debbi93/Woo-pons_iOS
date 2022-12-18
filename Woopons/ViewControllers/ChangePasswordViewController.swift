//
//  ChangePasswordViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        self.setBackButtonWithTitle(title: "")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        checkValidations()
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        
        if(oldPasswordTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter old password")
        }
        
        else if(newPasswordTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter new password")
        }
        else if(confirmPasswordTextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please confirm your password")
        }
        else {
            changePassword()
        }
        
    }
    
    
    // MARK: - Api Call's
    
    func changePassword() {
        
        let parameters: [String: Any] = [ "current_password": self.oldPasswordTextField.text ?? "" , "new_password":self.newPasswordTextField.text ?? ""]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.changePassword, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.showError(message: response["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
