//
//  PrivacyTermsViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit
import WebKit

class PrivacyTermsViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var titleString = ""
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.setBackButtonWithTitle(title: "")
        self.title = titleString
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.startActivityIndicator()
        let url = URL (string: urlString)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.stopActivityIndicator()
    }
}
