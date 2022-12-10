//
//  UnlockCouponViewController.swift
//  Woopons
//
//  Created by harsh on 07/12/22.
//

import UIKit

class UnlockCouponViewController: UIViewController {
    
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var couponCode: UILabel!
    
    var titleString = ""
    var orderId = 0
    var coupon = ""
    var count = 60
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        self.title =  titleString
        dottedView.addDashedBorder()
        self.couponCode.text = coupon
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if count != 0 {
            timer?.invalidate()
            self.unlockCoupon()
        }
    }
    
    @objc func updateCounter() {
        
        if count > 0 {
            self.timerLabel.text = "00:\(count)"
            count -= 1
        }
        else if count == 0 {
            timer?.invalidate()
            self.unlockCoupon()
        }
        
    }
    
    func unlockCoupon() {
        
        let parameters: [String: Any] = ["order_id":self.orderId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.unlockCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.showError(message: response["message"] as? String ?? "")
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
