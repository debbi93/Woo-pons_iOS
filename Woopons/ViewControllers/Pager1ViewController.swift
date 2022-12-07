//
//  Pager1ViewController.swift
//  Woopons
//
//  Created by Harshit Thakur on 20/11/22.
//

import UIKit


class Pager1ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        pushToPager2()
    }
    
}


