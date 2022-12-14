//
//  CouponDetailViewController.swift
//  Woopons
//
//  Created by harsh on 04/12/22.
//

import UIKit
import MTSlideToOpen
import Cosmos

class CouponDetailViewController: UIViewController, MTSlideToOpenDelegate {
   
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var redeemCouponView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var titleString = ""
    var couponDetail = Favorites()
    var isFromCouponTab = false
    var isHistory = false
    var rating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        self.detailTableView.estimatedRowHeight = 180
        self.detailTableView.rowHeight = UITableView.automaticDimension
        self.setBackButtonWithTitle(title: "")
        detailTableView.register(UINib(nibName: "DescriptionTableCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableCell")
        detailTableView.register(UINib(nibName: "GetCouponTableCell", bundle: nil), forCellReuseIdentifier: "GetCouponTableCell")
        detailTableView.register(UINib(nibName: "RateExperienceTableCell", bundle: nil), forCellReuseIdentifier: "RateExperienceTableCell")
        detailTableView.register(UINib(nibName: "ResetCouponTableCell", bundle: nil), forCellReuseIdentifier: "ResetCouponTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailTableView.reloadData()
    }
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpen.MTSlideToOpenView) {
       
        self.popupView.isHidden = false
        self.redeemCouponView.isHidden = false
        sender.resetStateWithAnimation(true)
    }
    
    func addReview () {
            
        let parameters: [String: Any] = ["rating":rating,"coupon_id":self.couponDetail.id,"order_id":self.couponDetail.orderId ]
            
            ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addReview, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
                
                    self.showError(message: response["message"] as? String ?? "")
                    self.navigationController?.popViewController(animated: true)
               // }
            }
        failure: { error in
            self.showError(message: error.localizedDescription)
        }
        
    }
    
    func addCoupon(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
           
            self.popupView.isHidden = false
            self.successView.isHidden = false
            self.successLabel.text = "Coupon Added"
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func removeCoupon(orderId:Int) {
        
        let parameters: [String: Any] = ["order_id":orderId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.removeCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.popupView.isHidden = false
            self.successView.isHidden = false
            self.successLabel.text = "Coupon Removed"
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func addRemoveFavorite(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addRemoveFavorite, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    @objc func getCouponAction(sender: UIButton){
        
        addCoupon(couponId: self.couponDetail.id)
        
    }
    
    @objc func removeCouponAction(sender: UIButton){
        
        removeCoupon(orderId: self.couponDetail.orderId)
    }
    
    // MARK: - Actions
     
     @IBAction func unlockButtonTapped(_ sender: UIButton) {
         
         self.popupView.isHidden = true
         self.redeemCouponView.isHidden = true
         self.pushToUnlockCoupon(title: self.titleString, coupon: self.couponDetail.couponCode,orderId: self.couponDetail.orderId)
         
     }
     @IBAction func noButtonTapped(_ sender: UIButton) {
         self.popupView.isHidden = true
         self.redeemCouponView.isHidden = true
     }
     @IBAction func okButtonTapped(_ sender: UIButton) {
         
         self.popupView.isHidden = true
         self.successView.isHidden = true
         self.navigationController?.popViewController(animated: true)
     }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        if self.couponDetail.rating == 0.0 {
            self.rating = rating
            addReview()
        }
    }
    
    @objc func favButtonAction(sender: UIButton){
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = detailTableView.cellForRow(at: indexPath) as? DescriptionTableCell
            if cell?.favButton.imageView?.image == UIImage(named: "heart"){
                cell?.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            else {
                cell?.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
        addRemoveFavorite(couponId: self.couponDetail.id)
        }
    
}

extension CouponDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHistory && self.couponDetail.ratingCount != 0{
            return 1
        }
        else {
            return 2
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableCell", for: indexPath) as! DescriptionTableCell
            cell.imgView.image = nil
            if !self.couponDetail.companyLogo.isEmpty {
                cell.imgView.setImage(with: self.couponDetail.companyLogo, placeholder: UIImage(named: "rectangle")!)
            }
            else {
                cell.imgView.image = UIImage(named: "rectangle")
            }
            cell.ratingLabel.text = "\(self.couponDetail.ratingAvergae) (\(self.couponDetail.ratingCount)) ratings"
            cell.ratingView.rating = self.couponDetail.ratingAvergae
            cell.nameLabel.text = self.couponDetail.companyName
            cell.locationLabel.text = self.couponDetail.companyLocation
            cell.repititionLabel.text = self.couponDetail.repetition
            cell.uniqueLabel.text = self.couponDetail.offer
            cell.aboutLabel.text = self.couponDetail.about
            cell.howToUseLabel.text = self.couponDetail.howToUse
            cell.favButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: #selector(favButtonAction(sender:)), for: .touchUpInside)
            if self.couponDetail.isfavorite {
                cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
            else {
                cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            
            return cell
            
        case 1:
            if isHistory && self.couponDetail.rating == 0.0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RateExperienceTableCell", for: indexPath) as! RateExperienceTableCell
                cell.ratingView.settings.fillMode = .half
                cell.ratingView.didFinishTouchingCosmos = self.didFinishTouchingCosmos
                return cell
            }
            else if (isFromCouponTab) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResetCouponTableCell", for: indexPath) as! ResetCouponTableCell
                cell.removeButton.addTarget(self, action: #selector(removeCouponAction(sender:)), for: .touchUpInside)
                cell.slider.delegate = self
                return cell
            }
            else if (!isHistory){
                let cell = tableView.dequeueReusableCell(withIdentifier: "GetCouponTableCell", for: indexPath) as! GetCouponTableCell
                cell.getCouponButton.addTarget(self, action: #selector(getCouponAction(sender:)), for: .touchUpInside)
                return cell
            }
            
        default:
           break
        }
        return UITableViewCell()
    }

    
}
