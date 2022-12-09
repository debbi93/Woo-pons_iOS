//
//  CouponsViewController.swift
//  Woopons
//
//  Created by harsh on 23/11/22.
//

import UIKit

class CouponsViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var historyButtonView: UIView!
    @IBOutlet weak var newButtonView: UIView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var couponsTableView: UITableView!
    @IBOutlet weak var errorImage: UIImageView!
    
    var isHistory = false
    var couponData : Coupon?
    var titleString = ""
    var couponCode = ""
    var orderId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.couponsTableView.delegate = self
        self.couponsTableView.dataSource = self
        // Do any additional setup after loading the view.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        couponsTableView.register(UINib(nibName: "FavoriteTableCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableCell")
        self.tabBarController?.title = "Coupons"
        self.couponsTableView.estimatedRowHeight = 80
        self.couponsTableView.rowHeight = UITableView.automaticDimension
        getCoupons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorImage.isHidden = true
        newButton.tintColor = UIColor(named: "primaryRed")
        historyButton.tintColor = UIColor(named: "black5")
        newButtonView.backgroundColor = UIColor(named: "primaryRed")
        historyButtonView.backgroundColor = .clear
        isHistory = false
        
    }
    
    // MARK: - Api Call's
    
    func getCoupons() {
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getMyCoupons , view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                self.couponData = Coupon.eventWithObject(data: dict)
                
                if ((self.couponData?.newlyAdded?.count ?? 0) == 0) {
                    self.errorImage.isHidden = false
                }
                else {
                    self.errorImage.isHidden = true
                }
                self.couponsTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func addRemoveFavorite(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addRemoveFavorite, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            self.showError(message: response["message"] as? String ?? "")
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }

    // MARK: - Actions
    
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        errorImage.isHidden = true
        historyButton.tintColor = UIColor(named: "primaryRed")
        newButton.tintColor = UIColor(named: "black5")
        historyButtonView.backgroundColor = UIColor(named: "primaryRed")
        newButtonView.backgroundColor = .clear
        isHistory = true
        if ((self.couponData?.history?.count ?? 0) == 0){
            self.errorImage.isHidden = false
        }
        else {
            self.errorImage.isHidden = true
        }
        self.couponsTableView.reloadData()
    }
    
    
    @IBAction func newButtonTapped(_ sender: UIButton) {
        errorImage.isHidden = true
        newButton.tintColor = UIColor(named: "primaryRed")
        historyButton.tintColor = UIColor(named: "black5")
        newButtonView.backgroundColor = UIColor(named: "primaryRed")
        historyButtonView.backgroundColor = .clear
        isHistory = false
        if ((self.couponData?.newlyAdded?.count ?? 0) == 0) {
            self.errorImage.isHidden = false
        }
        else {
            self.errorImage.isHidden = true
        }
        self.couponsTableView.reloadData()
    }
    
    @IBAction func unlockButtonTapped(_ sender: Any) {
        self.popupView.isHidden = true
        self.pushToUnlockCoupon(title: self.titleString, coupon: self.couponCode,orderId: self.orderId)
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        self.popupView.isHidden = true
    }
    
    @objc func couponDetailAction(sender: UIButton){
        if let data = self.couponData?.newlyAdded?[sender.tag] {
            pushToCouponDetail(couponDetail: data,titleString: data.companyName,isFromCouponTab: true,isHistory:false)
        }
    }
    
    @objc func getCouponAction(sender: UIButton){
        self.popupView.isHidden = false
        if let data = self.couponData?.newlyAdded?[sender.tag] {
            self.titleString = data.name
            self.couponCode = data.couponCode
            self.orderId = data.orderId
           
        }
    }
    
    @objc func historyDetailAction(sender: UIButton){
        
        if let data = self.couponData?.history?[sender.tag] {
            pushToCouponDetail(couponDetail: data,titleString: data.companyName,isFromCouponTab: false,isHistory:true)
            
        }
    }
    
    @objc func favButtonAction(sender: UIButton){
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        var couponId = 0
        if isHistory {
         
            let data = self.couponData?.history?[indexPath.row]
            couponId = data?.id ?? 0
            
        }
        else {
            let data = self.couponData?.newlyAdded?[indexPath.row]
            couponId = data?.id ?? 0
        }
        let cell = couponsTableView.cellForRow(at: indexPath) as? FavoriteTableCell
        if cell?.favButton.imageView?.image == UIImage(named: "heart"){
            cell?.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
        else {
            cell?.favButton.setImage(UIImage(named: "heart"), for: .normal)
        }
            addRemoveFavorite(couponId:couponId )
        }
    
}

extension CouponsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHistory {
            return self.couponData?.history?.count ?? 0
        }
        else {
            return self.couponData?.newlyAdded?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableCell
        
        
        if isHistory {
           let data = self.couponData?.history?[indexPath.row]
            
            if data?.isfavorite ?? false {
                cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
            else {
                cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            cell.favButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: #selector(favButtonAction(sender:)), for: .touchUpInside)
            cell.nameLabel.text = data?.name
            cell.typeLabel.text = data?.repetition
            cell.imgView.image = nil
            if let image = data?.companyLogo , !image.isEmpty {
                cell.imgView.setImage(with: image, placeholder: UIImage(named: "placeholder")!)
            }
            else {
                cell.imgView.image = UIImage(named: "placeholder")
            }
            cell.ratingLabel.text = "\(data?.ratingAvergae ?? 0.0) (\(data?.ratingCount ?? 0)) ratings"
            cell.ratingView.rating = data?.ratingAvergae ?? 0.0
            cell.detailsButton.tag = indexPath.row
            cell.typeLabel.isHidden = true
            cell.detailsButton.addTarget(self, action: #selector(historyDetailAction(sender:)), for: .touchUpInside)
            cell.couponButton.isHidden = true
            cell.labelTopConstraint.constant = 0
            cell.labelBottomConstraint.constant = 0
        }
        else {
            let data = self.couponData?.newlyAdded?[indexPath.row]
            cell.typeLabel.isHidden = false
            cell.couponButton.isHidden = false
            cell.labelTopConstraint.constant = 15
            cell.labelBottomConstraint.constant = 10
            if data?.isfavorite ?? false {
                cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
            else {
                cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            cell.nameLabel.text = data?.name
            cell.typeLabel.text = data?.repetition
            cell.imgView.image = nil
            if let image = data?.companyLogo , !image.isEmpty {
                cell.imgView.setImage(with: image, placeholder: UIImage(named: "placeholder")!)
            }
            else {
                cell.imgView.image = UIImage(named: "placeholder")
            }
            cell.favButton.tag = indexPath.row
            cell.favButton.addTarget(self, action: #selector(favButtonAction(sender:)), for: .touchUpInside)
            cell.ratingLabel.text = "\(data?.ratingAvergae ?? 0.0) (\(data?.ratingCount ?? 0)) ratings"
            cell.ratingView.rating = data?.ratingAvergae ?? 0.0
            cell.detailsButton.tag = indexPath.row
            cell.couponButton.setTitle("Unlock Coupon", for: .normal)
            cell.couponButton.underline(color: "primaryRed")
            cell.detailsButton.addTarget(self, action: #selector(couponDetailAction(sender:)), for: .touchUpInside)
            cell.couponButton.addTarget(self, action: #selector(getCouponAction(sender:)), for: .touchUpInside)
            cell.couponButton.tag = indexPath.row

        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isHistory {
            if let data = self.couponData?.history?[indexPath.row] {
               pushToCouponDetail(couponDetail: data,titleString: data.companyName,isFromCouponTab: false,isHistory: true)
            }
        }
        else {
            if let data = self.couponData?.newlyAdded?[indexPath.row] {
                pushToCouponDetail(couponDetail: data,titleString: data.companyName,isFromCouponTab: true,isHistory: false)
            }
        }
    }
    
}
