//
//  FavoritesViewController.swift
//  Woopons
//
//  Created by harsh on 22/11/22.
//

import UIKit

class FavoritesViewController: UIViewController {

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
                self.favoritesTableView.reloadData()
            }
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
        cell.imgView.setImage(with: data.companyLogo, placeholder: UIImage(named: "placeholder")!)
        cell.ratingLabel.text = "\(data.ratingAvergae) (\(data.rating)) ratings"
        cell.ratingView.rating = data.ratingAvergae
        cell.favButton.tag = indexPath.row
        cell.detailsButton.tag = indexPath.row
        cell.couponButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favoriteList[indexPath.row]
        pushToCouponDetail(couponDetail: data,titleString: data.companyName)
        
    }
    
}
