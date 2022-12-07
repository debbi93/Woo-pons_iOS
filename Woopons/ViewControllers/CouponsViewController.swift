//
//  CouponsViewController.swift
//  Woopons
//
//  Created by harsh on 23/11/22.
//

import UIKit

class CouponsViewController: UIViewController {
    
    @IBOutlet weak var historyButtonView: UIView!
    @IBOutlet weak var newButtonView: UIView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var couponsTableView: UITableView!
    @IBOutlet weak var errorImage: UIImageView!
    
    var isHistory = false
    var couponData : Coupon?
    
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

    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
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
            cell.nameLabel.text = data?.name
            cell.typeLabel.text = data?.repetition
            cell.imgView.setImage(with: data?.companyLogo ?? "", placeholder: UIImage(named: "placeholder")!)
            cell.ratingLabel.text = "\(data?.ratingAvergae ?? 0.0) (\(data?.rating ?? 0)) ratings"
            cell.ratingView.rating = data?.ratingAvergae ?? 0.0
            cell.favButton.tag = indexPath.row
            cell.detailsButton.tag = indexPath.row
            cell.couponButton.tag = indexPath.row
            cell.typeLabel.isHidden = true
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
            cell.imgView.setImage(with: data?.companyLogo ?? "", placeholder: UIImage(named: "placeholder")!)
            cell.ratingLabel.text = "\(data?.ratingAvergae ?? 0.0) (\(data?.rating ?? 0)) ratings"
            cell.ratingView.rating = data?.ratingAvergae ?? 0.0
            cell.favButton.tag = indexPath.row
            cell.detailsButton.tag = indexPath.row
            cell.couponButton.tag = indexPath.row
            cell.typeLabel.isHidden = true
            cell.couponButton.isHidden = true
            cell.labelTopConstraint.constant = 0
            cell.labelBottomConstraint.constant = 0
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
