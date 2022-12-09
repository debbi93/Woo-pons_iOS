//
//  FeedbackViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.setBackButtonWithTitle(title: "")
        self.title = "Feedback & Suggestions"
        messageTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Share your thoughts..."
        placeholderLabel.font = UIFont.init(name: "Poppins-Regular", size: messageTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        checkValidations()
        
    }
    
    func checkValidations(){
        self.view.endEditing(true)
        if(messageTextView.text!.isEmptyOrWhitespace)() && !(placeholderLabel.text?.isEmpty ?? false) {
            self.showError(message: "Please enter your feedback")
        }
        else {
            sendFeedback()
        }
    }
    
    func sendFeedback() {
        
        let parameters: [String: Any] = ["feedback":self.messageTextView.text ?? "" ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.sendFeedback, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.showError(message: response["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
}

extension FeedbackViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
