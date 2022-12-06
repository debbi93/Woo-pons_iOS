//
//  CodeViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class CodeViewController: UIViewController {
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        pushToChangePassword()
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        if(code1TextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter your 4 digit code")
        }
        else if(code2TextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please enter your 4 digit code")
        }
        else if(code3TextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please enter your 4 digit code")
        }
        else if(code4TextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please enter your 4 digit code")
        }
    }
    
    func forgotPassword() {
        
        let parameters: [String: Any] = ["email":self.code1TextField.text ?? "" ]
        
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
