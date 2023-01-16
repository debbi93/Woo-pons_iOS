//
//  UnlockCouponViewController.swift
//  Woopons
//
//  Created by harsh on 07/12/22.
//

import UIKit

protocol FirstControllerDelegate: AnyObject {
    func sendData(goBack: Bool)
}

class UnlockCouponViewController: UIViewController,FirstControllerDelegate {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var couponCode: UILabel!
    
    var titleString = ""
    var descString = ""
    var orderId = 0
    var coupon = ""
    var count = 60
    var timer: Timer?
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setScreenCaptureProtection()
        self.title =  titleString
        self.descLabel.text = descString
         dottedView.addDashedBorder()
        self.couponCode.text = coupon
        NotificationCenter.default.addObserver(self, selector: #selector(self.background(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.foreground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.unlockCoupon()
        let closeButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(UnlockCouponViewController.barButtonDidTap(_:)))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func sendData(goBack: Bool) {
        couponCode.isHidden = false
        if goBack {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func background(_ notification: Notification) {
        userDefault.setValue(count, forKey: "OTPTimer")
        userDefault.setValue(Date(), forKey: "OTPTimeStamp")
    }
    
    @objc func foreground(_ notification: Notification) {
        let timerValue = userDefault.value(forKey: "OTPTimer") as? Int ?? 0
        let otpTimeStamp = userDefault.value(forKey: "OTPTimeStamp") as? Date
        let components = Calendar.current.dateComponents([.second], from: otpTimeStamp ?? Date(), to: Date())
        self.count = timerValue - (components.second ?? 0)
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem)
    {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "UnlockCouponPopUp") as! UnlockCouponPopUp
        secondVC.delegate = self
        couponCode.isHidden = true
        secondVC.modalPresentationStyle = .overCurrentContext
        self.present(secondVC, animated: false)
    }
    
    @objc func updateCounter() {
        
        if count > 0 {
                self.timerLabel.text = "0:0\(count)"
            }
            else {
                self.timerLabel.text = "0:\(count)"
            }
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
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
}
private extension UIView {
    func setScreenCaptureProtection() {
        guard superview != nil else {
            for subview in subviews { //to avoid layer cyclic crash, when it is a topmost view, adding all its subviews in textfield's layer, TODO: Find a better logic.
                subview.setScreenCaptureProtection()
            }
            return
        }
        let guardTextField = UITextField()
        guardTextField.backgroundColor = .clear
        guardTextField.translatesAutoresizingMaskIntoConstraints = false
        guardTextField.isSecureTextEntry = true
        addSubview(guardTextField)
        guardTextField.isUserInteractionEnabled = false
        sendSubviewToBack(guardTextField)
        layer.superlayer?.addSublayer(guardTextField.layer)
        guardTextField.layer.sublayers?.first?.addSublayer(layer)
        guardTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        guardTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        guardTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        guardTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
}
