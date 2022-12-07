//
//  CouponDetailViewController.swift
//  Woopons
//
//  Created by harsh on 04/12/22.
//

import UIKit

class CouponDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var titleString = ""
    var couponDetail = Favorites()
    var isFromCouponTab = false
    var isHistory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        self.detailTableView.estimatedRowHeight = 180
        self.detailTableView.rowHeight = UITableView.automaticDimension
        self.setBackButtonWithTitle(title: "")
        detailTableView.register(UINib(nibName: "DescriptionTableCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableCell")
        detailTableView.register(UINib(nibName: "GetCouponTableCell", bundle: nil), forCellReuseIdentifier: "GetCouponTableCell")
        detailTableView.register(UINib(nibName: "RateExperienceTableCell", bundle: nil), forCellReuseIdentifier: "RateExperienceTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailTableView.reloadData()
    }
    
    func addCoupon(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            self.showError(message: response["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    @objc func getCouponAction(sender: UIButton){
        
        addCoupon(couponId: self.couponDetail.id)
        
    }
}


extension CouponDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableCell", for: indexPath) as! DescriptionTableCell
            
            cell.imgView.setImage(with: self.couponDetail.companyLogo, placeholder: UIImage(named: "placeholder")!)
            cell.ratingLabel.text = "\(self.couponDetail.ratingAvergae) (\(self.couponDetail.rating)) ratings"
            cell.ratingView.rating = self.couponDetail.ratingAvergae
            cell.nameLabel.text = self.couponDetail.companyName
            cell.locationLabel.text = self.couponDetail.companyLocation
            cell.repititionLabel.text = self.couponDetail.repetition
            cell.uniqueLabel.text = self.couponDetail.offer
            cell.aboutLabel.text = self.couponDetail.about
            cell.howToUseLabel.text = self.couponDetail.howToUse
            if self.couponDetail.isfavorite {
                cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
            else {
                cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            
            return cell
            
        case 1:
            if isHistory {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RateExperienceTableCell", for: indexPath) as! RateExperienceTableCell
                return cell
            }
            else if (isFromCouponTab) {
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GetCouponTableCell", for: indexPath) as! GetCouponTableCell
                cell.getCouponButton.tag = indexPath.row
                cell.getCouponButton.addTarget(self, action: #selector(getCouponAction(sender:)), for: .touchUpInside)
                return cell
            }
            
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
}
