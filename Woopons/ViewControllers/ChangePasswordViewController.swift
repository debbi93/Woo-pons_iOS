//
//  ChangePasswordViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var confirmEye: UIButton!
    @IBOutlet weak var newEye: UIButton!
    @IBOutlet weak var oldEye: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var oldIconClick = true
    var newIconClick = true
    var confirmIconClick = true
    
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
        else if !(confirmPasswordTextField.text!.elementsEqual(self.newPasswordTextField.text!)){
            self.showError(message: "Passwords do not match")
        }
        else {
            changePassword()
        }
        
    }
    
    @IBAction func oldEyeAction(_ sender: UIButton) {
        if oldIconClick {
            oldPasswordTextField.isSecureTextEntry = false
            oldEye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            oldPasswordTextField.isSecureTextEntry = true
            oldEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        oldIconClick = !oldIconClick
    }
    
    @IBAction func newEyeAction(_ sender: UIButton) {
        if newIconClick {
            newPasswordTextField.isSecureTextEntry = false
            newEye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            newPasswordTextField.isSecureTextEntry = true
            newEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        newIconClick = !newIconClick
    }
    
    @IBAction func confirmEyeAction(_ sender: UIButton) {
        if confirmIconClick {
            confirmPasswordTextField.isSecureTextEntry = false
            confirmEye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            confirmEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        confirmIconClick = !confirmIconClick
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
