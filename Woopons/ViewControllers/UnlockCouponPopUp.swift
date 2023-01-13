//
//  UnlockCouponPopUp.swift
//  Woopons
//
//  Created by harsh on 07/12/22.
//

import UIKit


class UnlockCouponPopUp: UIViewController {

    var couponId = ""
    var titleString = ""
    var orderId = 0
    var descString = ""
    weak var delegate: FirstControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        delegate.sendData(goBack: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func unlockButtonTapped(_ sender: UIButton) {
        
        delegate.sendData(goBack: true)
        self.dismiss(animated: true)
        }
    
}
