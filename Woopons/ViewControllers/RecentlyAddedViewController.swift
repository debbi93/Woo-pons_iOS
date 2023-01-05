//
//  RecentlyAddedViewController.swift
//  Woopons
//
//  Created by harsh on 28/11/22.
//

import UIKit

class RecentlyAddedViewController: UIViewController {
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var recentlyAddedTableView: UITableView!
    
    var recentlyAdded = [Favorites]()
    var page = 1
    var contentOffSet = CGFloat()
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recently added"
        self.setBackButtonWithTitle(title: "")
        recentlyAddedTableView.estimatedRowHeight = UITableView.automaticDimension
        recentlyAddedTableView.rowHeight = UITableView.automaticDimension
        recentlyAddedTableView.register(UINib(nibName: "RecentlyAddedTableCell", bundle: nil), forCellReuseIdentifier: "RecentlyAddedTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecentlyAdded()
    }
    
    // MARK: - Api Call's
    
    func getRecentlyAdded() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getAllRecentlyAdded + "\(page)&limit=20", view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                let data = Favorites.eventWithObject(data: dict)
                if self.page == 1 {
                    self.recentlyAdded.removeAll()
                }
                if(data.count > 0){
                    self.recentlyAdded.append(contentsOf: data)
                }
                if let total = response["data"] as? [String:AnyObject] {
                    self.totalCount = total["total_count"] as? Int ?? 0
                }
                if self.totalCount == 0 {
                    self.errorImage.isHidden = false
                }
                else {
                    self.errorImage.isHidden = true
                }
                self.recentlyAddedTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffSet = self.recentlyAddedTableView.contentOffset.y;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.recentlyAddedTableView && (self.recentlyAdded.count) < self.totalCount {
            if ((self.recentlyAddedTableView.contentOffset.y + self.recentlyAddedTableView.frame.size.height) >= self.recentlyAddedTableView.contentSize.height){
                self.page += 1
                getRecentlyAdded()
            }
        }
    }
    
    @objc func couponDetailAction(sender: UIButton){
        let data = recentlyAdded[sender.tag]
        pushToCouponDetail(couponDetail: data,titleString: data.name,isFromCouponTab: false,isHistory:false)
    }
}


extension RecentlyAddedViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentlyAdded.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyAddedTableCell", for: indexPath) as! RecentlyAddedTableCell
        
        let recentData = self.recentlyAdded[indexPath.row]
        cell.imgView.image = nil
        if !recentData.companyLogo.isEmpty {
            cell.imgView.setImage(with: recentData.companyLogo, placeholder: UIImage(named: "rectangle")!)
            cell.nameView.isHidden = true
        }
        else {
            cell.nameView.isHidden = false
            cell.imgView.image = UIImage(named: "rectangle")
        }
        cell.imageNameLbl.text = recentData.companyName.getAcronyms().uppercased()
        cell.nameLabel.text = recentData.name
        cell.categoryLabel.text = recentData.companyCategory
        cell.typeLabel.text = recentData.repetition
        cell.detailButton.tag = indexPath.section
        cell.detailButton.addTarget(self, action: #selector(couponDetailAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recentData = self.recentlyAdded[indexPath.row]
        pushToCouponDetail(couponDetail: recentData,titleString: recentData.name,isFromCouponTab: false,isHistory:false)
        
    }
    
}
