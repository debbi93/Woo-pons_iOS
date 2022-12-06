//
//  ChangePasswordViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Password"
        self.setBackButtonWithTitle(title: "")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        if(newPasswordTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter new password")
        }
        else if(confirmPasswordTextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please confirm your password")
        }
     
    }
}
