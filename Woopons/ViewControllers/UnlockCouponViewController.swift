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
        self.unlockCoupon()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateCounter() {
        
        if count > 0 {
            self.timerLabel.text = "00:\(count)"
            count -= 1
        }
        else if count == 0 {
            timer?.invalidate()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func unlockCoupon() {
        
        let parameters: [String: Any] = ["order_id":self.orderId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.unlockCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.showError(message: response["message"] as? String ?? "")
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
