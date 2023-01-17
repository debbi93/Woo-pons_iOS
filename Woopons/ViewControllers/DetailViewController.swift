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
   
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var sliderView: MTSlideToOpenView!
    
    var titleString = ""
    var couponDetail = Favorites()
    var isFromCouponTab = false
    var isHistory = false
    var rating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        sliderView.delegate = self
        self.detailTableView.estimatedRowHeight = 180
        self.detailTableView.rowHeight = UITableView.automaticDimension
        self.setBackButtonWithTitle(title: "")
        setUpSlider()
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
    
    func setUpSlider(){
        sliderView.sliderViewTopDistance = 0
        sliderView.labelText = "Slide To Unlock"
        sliderView.slidingColor = .clear
        sliderView.layer.cornerRadius = 20
        sliderView.textColor = UIColor(named: "yellowText")!
        sliderView.sliderBackgroundColor = .clear
        sliderView.thumbnailColor = .clear
        sliderView.tintColor = .clear
        sliderView.thumnailImageView.image = UIImage(named: "slider")
    }
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpen.MTSlideToOpenView) {
       
        self.popupView.isHidden = true
        self.unlockView.isHidden = true
        sender.resetStateWithAnimation(true)
        addCoupon(couponId: self.couponDetail.id)
  //  self.pushToUnlockCoupon(title: "self.couponDetail.name", coupon: "self.couponDetail.couponCode", orderId: 0, desc: "self.couponDetail.businessDescription")
        
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
           
            if let dict = response["data"] as? [String:AnyObject] {
                let upgradeBool = dict["plan_type_upgrade"] as? Bool ?? false
                if upgradeBool  {
                    self.popupView.isHidden = false
                    self.errorView.isHidden = false
                    self.errorMessageLbl.text = response["message"] as? String ?? ""
                }
                else {
                    let orderId = dict["id"] as? Int ?? 0
                    self.pushToUnlockCoupon(title: self.couponDetail.name, coupon: self.couponDetail.couponCode, orderId: orderId, desc: self.couponDetail.businessDescription)
                }
            }
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
//    func removeCoupon(orderId:Int) {
//
//        let parameters: [String: Any] = ["order_id":orderId]
//
//        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.removeCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
//
//            self.popupView.isHidden = false
//            self.successView.isHidden = false
//            self.successLabel.text = "Coupon Removed"
//        }
//    failure: { error in
//        self.showError(message: error.localizedDescription)
//    }
//    }
    
    func addRemoveFavorite(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addRemoveFavorite, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    @objc func getCouponAction(sender: UIButton){
        
        self.popupView.isHidden = false
        self.unlockView.isHidden = false
        
    }
    
    // MARK: - Actions
     
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        self.popupView.isHidden = true
        self.unlockView.isHidden = true
        self.errorView.isHidden = true
        self.pushToWebView(title: "Upgrade Plan",url: "\(Constants.AppUrls.imageBaseUrl)/?access_token=\(UserDefaults.standard.string(forKey: "accessToken") ?? "")")

    }
    
     @IBAction func noButtonTapped(_ sender: UIButton) {
         self.popupView.isHidden = true
         self.unlockView.isHidden = true
         self.errorView.isHidden = true
     }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        if self.couponDetail.rating == 0.0 {
            self.rating = rating
            addReview()
        }
    }
    
    @objc func directionsButtonAction(sender: UIButton){
       
        let url = "http://maps.apple.com/maps?daddr=\(self.couponDetail.lat),\(self.couponDetail.lng)"
        UIApplication.shared.openURL(URL(string:url)!)

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
            cell.imageNameLbl.text = self.couponDetail.companyName.getAcronyms().uppercased()
            if !self.couponDetail.companyLogo.isEmpty {
                cell.imgView.setImage(with: self.couponDetail.companyLogo, placeholder: UIImage(named: "rectangle")!)
                cell.nameView.isHidden = true
            }
            else {
                cell.imgView.image = UIImage(named: "rectangle")
                cell.nameView.isHidden = false
            }
            cell.ratingLabel.text = "\(self.couponDetail.ratingAvergae)"
            cell.ratingView.rating = self.couponDetail.ratingAvergae
            cell.nameLabel.text = self.couponDetail.companyName
            cell.locationLabel.text = self.couponDetail.companyLocation
            cell.repititionLabel.text = self.couponDetail.repetition
            cell.uniqueLabel.text = self.couponDetail.offer
            cell.aboutLabel.text = self.couponDetail.about
            cell.howToUseLabel.text = self.couponDetail.howToUse
            cell.aboutCompanyLbl.text = "About \(self.couponDetail.companyName)"
            cell.aboutCompanyDescLbl.text = self.couponDetail.businessDescription
            cell.potentialLbl.text = "\(self.couponDetail.companyName) has been operating for..."
            cell.potentialDescLbl.text = self.couponDetail.howLongBusiness
            cell.howLongLbl.text = "\(self.couponDetail.companyName) would like you to know"
            cell.howLongDescLbl.text = self.couponDetail.potential
            cell.favButton.tag = indexPath.row
            cell.directionsButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: #selector(favButtonAction(sender:)), for: .touchUpInside)
            cell.directionsButton.addTarget(self, action: #selector(directionsButtonAction(sender:)), for: .touchUpInside)
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
//            else if (isFromCouponTab) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ResetCouponTableCell", for: indexPath) as! ResetCouponTableCell
//                cell.removeButton.addTarget(self, action: #selector(removeCouponAction(sender:)), for: .touchUpInside)
//                cell.slider.delegate = self
//                return cell
//            }
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
