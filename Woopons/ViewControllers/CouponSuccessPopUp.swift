//
//  CouponSuccessPopUp.swift
//  Woopons
//
//  Created by harsh on 07/12/22.
//

import UIKit

class CouponSuccessPopUp: UIViewController {

    @IBOutlet weak var successLabel: UILabel!
    
    var textString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.successLabel.text = textString
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
