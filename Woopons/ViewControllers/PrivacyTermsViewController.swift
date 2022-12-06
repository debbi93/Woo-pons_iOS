//
//  PrivacyTermsViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit
import WebKit

class PrivacyTermsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var titleString = ""
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        self.title = titleString
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL (string: urlString)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }
    
}
