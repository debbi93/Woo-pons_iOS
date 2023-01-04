//
//  FavoritesViewController.swift
//  Woopons
//
//  Created by harsh on 22/11/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteList = [Favorites]()
    var page = 1
    var contentOffSet = CGFloat()
    var totalCount = 0
    var pageTitle = ""
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        self.setBackButtonWithTitle(title: "")
        favoritesTableView.register(UINib(nibName: "FavoriteTableCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        self.popUpView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
   
    // MARK: - Api Call's
    
    func getFavorites() {
        
        ApiService.getAPIWithoutParameters(urlString: urlString + "\(page)&limit=20", view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                let data = Favorites.eventWithObject(data: dict)
                if self.page == 1 {
                    self.favoriteList.removeAll()
                }
                if(data.count > 0){
                    self.favoriteList.append(contentsOf: data)
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
                self.favoritesTableView.reloadData()
            }
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
    
    func addCoupon(couponId:Int) {
        
        let parameters: [String: Any] = ["coupon_id":couponId]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.addCoupon, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            self.popUpView.isHidden = false
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffSet = self.favoritesTableView.contentOffset.y;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.favoritesTableView && (self.favoriteList.count) < self.totalCount {
            if ((self.favoritesTableView.contentOffset.y + self.favoritesTableView.frame.size.height) >= self.favoritesTableView.contentSize.height){
                self.page += 1
                getFavorites()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func couponDetailAction(sender: UIButton){
        let data = favoriteList[sender.tag]
        pushToCouponDetail(couponDetail: data,titleString: data.name,isFromCouponTab: false,isHistory:false)
    }
    
    @objc func getCouponAction(sender: UIButton){
        
        let data = favoriteList[sender.tag]
        addCoupon(couponId: data.id)
    }
    
    @objc func favButtonAction(sender: UIButton){
        if self.pageTitle != "My Favorites" {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = favoritesTableView.cellForRow(at: indexPath) as? FavoriteTableCell
            if cell?.favButton.imageView?.image == UIImage(named: "heart"){
                cell?.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
            else {
                cell?.favButton.setImage(UIImage(named: "heart"), for: .normal)
            }
            addRemoveFavorite(couponId: self.favoriteList[sender.tag].id)
        }
    }
}

extension FavoritesViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableCell", for: indexPath) as! FavoriteTableCell
        let data = favoriteList[indexPath.row]
        
        cell.nameLabel.text = data.name
        if data.isfavorite {
            cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        else {
            cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
        cell.typeLabel.text = data.repetition
        cell.imgView.image = nil
        if !data.companyLogo.isEmpty {
            cell.imgView.setImage(with: data.companyLogo, placeholder: UIImage(named: "rectangle")!)
        }
        else {
            cell.imgView.image = UIImage(named: "rectangle")
        }
        cell.ratingLabel.text = "\(data.ratingAvergae)"
        cell.ratingView.rating = data.ratingAvergae
        cell.favButton.tag = indexPath.row
        cell.detailsButton.tag = indexPath.row
        cell.couponButton.tag = indexPath.row
        cell.couponButton.underline(color: "primaryRed")
        cell.detailsButton.addTarget(self, action: #selector(couponDetailAction(sender:)), for: .touchUpInside)
        cell.couponButton.addTarget(self, action: #selector(getCouponAction(sender:)), for: .touchUpInside)
        cell.favButton.addTarget(self, action: #selector(favButtonAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favoriteList[indexPath.row]
        pushToCouponDetail(couponDetail: data,titleString: data.name,isFromCouponTab: false,isHistory:false)
    }
}
