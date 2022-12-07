//
//  HomeViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var headerTitles = ["Select categories", "Recently added", "Top brands", "Trending categories"]
    var dashboardData : Home?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.tableHeaderView = headerView
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        homeTableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        self.tabBarController?.title = "Home"
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDashboardData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.setImage(UIImage(named: "search-bar"), for: .search, state: .normal)
        searchBar.tintColor = .white
        for subView in searchBar.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UINavigationButton")!) {
                    let cancelButton = view as! UIButton
                    cancelButton.tintColor = UIColor.white
                }
                
            }
        }
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor(named: "black3")
            textfield.backgroundColor = UIColor.clear
            textfield.font = UIFont.init(name: "Poppins-Light", size: 15.0)
        }
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
    }
    
    @objc func viewAllButtonClick(sender:UIButton)
    {
        switch sender.tag {
        case 0:
            self.pushToCategories()
        case 1:
            self.pushToRecentlyAdded()
        case 2:
            self.pushToTopBrands()
        case 3:
            self.pushToTrendingCategories()
        default:
            break
        }
    }
    
    func getDashboardData() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getHomeData, view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                self.dashboardData =  Home.eventWithObject(data: dict)
                self.homeTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    // MARK: - SearchBar Delegates
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.view.endEditing(true)
        self.homeTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 0){
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
            self.perform(#selector(search), with: nil, afterDelay: 1)
        }
        else{
            self.getDashboardData()
            self.homeTableView.reloadData()
        }
    }
    
    @objc func search(){
        
        let parameters: [String: Any] = ["search":self.searchBar.text ?? "" ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.searchData, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            if let dict = response as? [String:AnyObject] {
                self.dashboardData =  Home.eventWithObject(data: dict)
                self.homeTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dashboardData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.dashboardData?.categoryList?.count ?? 0 > 0 {
                return 80
            }
            else {
                return 0
            }
        case 1:
            if self.dashboardData?.recentList?.count ?? 0 > 0 {
                return 180
            }
            else {
                return 0
            }
        case 2:
            if self.dashboardData?.topBrands?.count ?? 0 > 0 {
                return 80
            }
            else {
                return 0
            }
        case 3:
            if self.dashboardData?.trendingCategories?.count ?? 0 > 0 {
                return 130
            }
            else {
                return 0
            }
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 20))
        header.addSubview(titleLabel)
        let viewButton = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: 0, width: 100, height: 20))
        viewButton.setTitleColor(UIColor(named: "primaryRed"), for: .normal)
        viewButton.titleLabel!.font = UIFont.init(name: "Poppins-Regular", size: 16.0)
        viewButton.setTitle("View all", for: .normal)
        viewButton.underline(color: "primaryRed")
        header.addSubview(viewButton)
        titleLabel.textColor = .black
        titleLabel.font = UIFont.init(name: "Poppins-Regular", size: 16.0)
        titleLabel.text = headerTitles[section]
        viewButton.tag = section
        viewButton.addTarget(self, action: #selector(HomeViewController.viewAllButtonClick(sender:)),for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if self.dashboardData?.categoryList?.count ?? 0 > 0 {
                return 30
            }
            else {
                return 0
            }
        case 1:
            if self.dashboardData?.recentList?.count ?? 0 > 0 {
                return 30
            }
            else {
                return 0
            }
        case 2:
            if self.dashboardData?.topBrands?.count ?? 0 > 0 {
                return 30
            }
            else {
                return 0
            }
        case 3:
            if self.dashboardData?.trendingCategories?.count ?? 0 > 0 {
                return 30
            }
            else {
                return 0
            }
        default:
            return 30
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as? HomeTableCell {
            cell.sectionTag = indexPath.section
            cell.homeSection1Delegate = self
            cell.homeSection2Delegate = self
            cell.homeSection4Delegate = self
            switch indexPath.section {
            case 0:
                cell.loadCategoriesSection(categories: self.dashboardData?.categoryList)
            case 1:
                cell.loadRecentsSection(recents: self.dashboardData?.recentList)
            case 2:
                cell.loadBrandsSection(brands: self.dashboardData?.topBrands)
            case 3:
                cell.loadTrendingSection(categories: self.dashboardData?.trendingCategories)
            default:
                break
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
}


extension HomeTableCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func loadCategoriesSection(categories : [AllCategories]?) {
        self.categories = categories
        self.homeTableCollectionCell.reloadData()
    }
    
    func loadRecentsSection(recents : [Favorites]?) {
        self.recentList = recents
        self.homeTableCollectionCell.reloadData()
    }
    
    func loadBrandsSection(brands : [TopBrands]?) {
        self.topBrands = brands
        self.homeTableCollectionCell.reloadData()
    }
    
    func loadTrendingSection(categories : [TrendingCategories]?) {
        self.trendingCategories = categories
        self.homeTableCollectionCell.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch sectionTag {
            
        case 0:
            return self.categories?.count ?? 0
        case 1:
            return self.recentList?.count ?? 0
        case 2:
            return self.topBrands?.count ?? 0
        case 3:
            return self.trendingCategories?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sectionTag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
            
            let categoryData = self.categories?[indexPath.item]
            cell.categoryNameLabel.text = categoryData?.name
            cell.categoryImgView.setImage(with: categoryData?.image ?? "", placeholder: UIImage(named: "placeholder")!)
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentsCollectionCell", for: indexPath) as! RecentsCollectionCell
            let recentData = self.recentList?[indexPath.item]
            cell.imgView.setImage(with: recentData?.companyLogo ?? "", placeholder: UIImage(named: "placeholder")!)
            cell.nameLabel.text = recentData?.companyName
            cell.categoryLabel.text = recentData?.companyCategory
            cell.typeLabel.text = recentData?.repetition
            cell.detailButton.tag = indexPath.section
            return cell
            
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
            cell.bgView.isHidden = true
            cell.categoryNameLabel.isHidden = true
            let categoryData = self.topBrands?[indexPath.item]
            cell.categoryImgView.setImage(with: categoryData?.image ?? "", placeholder: UIImage(named: "placeholder")!)
            return cell
            
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionCell", for: indexPath) as! TrendingCollectionCell
            let trendingData = self.trendingCategories?[indexPath.item]
            cell.categoryLabel.text = trendingData?.name
            cell.exploreButton.tag = indexPath.item
            cell.imgView.setImage(with: trendingData?.image ?? "", placeholder: UIImage(named: "placeholder")!)
            return cell
            
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sectionTag {
        case 0:
            let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionCell
            self.homeSection1Delegate?.collectionView(collectionviewcell: cell, index: indexPath, sectionTag: sectionTag, didTappedInTableViewCell: self)
        case 1:
            let cell = collectionView.cellForItem(at: indexPath) as? RecentsCollectionCell
            self.homeSection2Delegate?.collectionView(collectionviewcell: cell, index: indexPath,sectionTag: sectionTag, didTappedInTableViewCell: self)
        case 2:
            let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionCell
            self.homeSection1Delegate?.collectionView(collectionviewcell: cell, index: indexPath,sectionTag: sectionTag, didTappedInTableViewCell: self)
        case 3:
            let cell = collectionView.cellForItem(at: indexPath) as? TrendingCollectionCell
            self.homeSection4Delegate?.collectionView(collectionviewcell: cell, index: indexPath, sectionTag: sectionTag,didTappedInTableViewCell: self)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch sectionTag {
        case 0:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2.3) - 20), height: 80)
        case 1:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 1.5) - 10), height: 180)
        case 2:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2.5) - 20), height: 80)
        case 3:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 1.2) - 10), height: 130)
        default:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 10), height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension HomeViewController : HomeSection1Delegate {
    
    
    func collectionView(collectionviewcell: CategoriesCollectionCell?, index: IndexPath,sectionTag: Int, didTappedInTableViewCell: HomeTableCell) {
        
        if sectionTag == 0 {
            let data =  self.dashboardData?.categoryList?[index.item]
            self.pushToFavorites(pageTitle: data?.name ?? "", urlString: "\(Constants.AppUrls.getCouponsFromCategory)\(data?.id ?? 0)?page=")
        }
        else {
            let data = self.dashboardData?.topBrands?[index.item]
            self.pushToFavorites(pageTitle: data?.name ?? "", urlString: "\(Constants.AppUrls.getCouponsFromBrand)\(data?.id ?? 0)?page=")
        }
    }
}

extension HomeViewController : HomeSection2Delegate {
    
    func collectionView(collectionviewcell: RecentsCollectionCell?, index: IndexPath,sectionTag: Int, didTappedInTableViewCell: HomeTableCell) {
        
        if let data = self.dashboardData?.recentList?[index.row] {
            pushToCouponDetail(couponDetail: data,titleString: data.companyName)
        }
    }
}

extension HomeViewController : HomeSection4Delegate {
    
    func collectionView(collectionviewcell: TrendingCollectionCell?, index: IndexPath,sectionTag: Int, didTappedInTableViewCell: HomeTableCell) {
        
        let data =  self.dashboardData?.trendingCategories?[index.item]
        self.pushToFavorites(pageTitle: data?.name ?? "", urlString: "\(Constants.AppUrls.getCouponsFromCategory)\(data?.id ?? 0)?page=")
    }
}



// MARK: - UIView Extension
extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = CGAffineTransformRotate(self.transform, radians);
        self.transform = rotation
    }
    
}
