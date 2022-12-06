//
//  TrendingCategoryViewController.swift
//  Woopons
//
//  Created by harsh on 03/12/22.
//

import UIKit

class TrendingCategoryViewController: UIViewController {

    @IBOutlet weak var trendingCategoryTableView: UITableView!
    
    var trendingCategory = [AllCategories]()
    var page = 1
    var contentOffSet = CGFloat()
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trending categories"
        self.trendingCategoryTableView.estimatedRowHeight = 180
        self.trendingCategoryTableView.rowHeight = UITableView.automaticDimension
        self.setBackButtonWithTitle(title: "")
        trendingCategoryTableView.register(UINib(nibName: "TrendingTableCell", bundle: nil), forCellReuseIdentifier: "TrendingTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gettrendingCategory()
    }
    
    // MARK: - Api Call's
    
    func gettrendingCategory() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getTrendingCategory + "\(page)&limit=20", view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                let data = AllCategories.eventWithObject(data: dict)
                if self.page == 1 {
                    self.trendingCategory.removeAll()
                }
                if(data.count > 0){
                    self.trendingCategory.append(contentsOf: data)
                }
                if let total = response["data"] as? [String:AnyObject] {
                    self.totalCount = total["total_count"] as? Int ?? 0
                }
                self.trendingCategoryTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffSet = self.trendingCategoryTableView.contentOffset.y;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.trendingCategoryTableView && (self.trendingCategory.count) < self.totalCount {
            if ((self.trendingCategoryTableView.contentOffset.y + self.trendingCategoryTableView.frame.size.height) >= self.trendingCategoryTableView.contentSize.height){
                self.page += 1
                gettrendingCategory()
            }
        }
    }
}


extension TrendingCategoryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableCell", for: indexPath) as! TrendingTableCell
        
        let trendingData = self.trendingCategory[indexPath.row]
        cell.titleLabel.text = trendingData.name
        cell.exploreButton.tag = indexPath.row
        cell.descLabel.text = trendingData.description
        cell.imgView.setImage(with: trendingData.image, placeholder: UIImage(named: "placeholder")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data =  self.trendingCategory[indexPath.row]
        self.pushToFavorites(pageTitle: data.name, urlString: "\(Constants.AppUrls.getCouponsFromCategory)\(data.id)?page=")
        
    }
    
}
