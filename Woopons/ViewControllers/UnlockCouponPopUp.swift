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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func unlockButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            self.pushToUnlockCoupon(title: self.titleString, coupon: self.couponId,orderId: self.orderId, desc: self.descString)

        }
      
    }
}
