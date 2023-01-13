//
//  HomeViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class HomeViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var popupView: UIView!
    
    var headerTitles = ["Select categories", "Recently added", "Featured brands", "Trending categories"]
    var buttonTitles = ["View all", "View all","View all","View all"]
    let previousDate = UserDefaults.standard.value(forKey: "currentDate") as? Date
    
    var dashboardData : Home?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        homeTableView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        searchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        if previousDate == nil {
            UserDefaults.standard.set(Date(), forKey: "currentDate")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let components = Calendar.current.dateComponents([.day], from: previousDate ?? Date(), to: Date())
        if (components.day ?? 0) > 7 {
            self.popupView.isHidden = false
        }
        getDashboardData()
        self.tabBarController?.title = "Home"
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
            textfield.textColor = .black
            textfield.tintColor = UIColor(named: "primaryRed")
            textfield.backgroundColor = UIColor.clear
            textfield.font = UIFont.init(name: "Poppins-Light", size: 15.0)
        }
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchBar.text?.removeAll()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
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
        self.errorImage.isHidden = true
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getHomeData, view: self.view) { response in
            self.homeTableView.isHidden = false
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
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.view.endEditing(true)
        self.homeTableView.reloadData()
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
                if self.dashboardData?.categoryList?.count == 0 && self.dashboardData?.topBrands?.count ==  0 {
                    self.homeTableView.isHidden = true
                    self.errorImage.isHidden = false
                }
                else {
                    self.homeTableView.isHidden = false
                    self.errorImage.isHidden = true
                    
                }
                self.homeTableView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.popupView.isHidden = true
    }
    
    @IBAction func viewBtnAction(_ sender: UIButton) {
        self.popupView.isHidden = true
        UserDefaults.standard.set(Date(), forKey: "currentDate")
        self.pushToTopBrands()
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
                return 90
            }
            else {
                return 0
            }
        case 1:
            if self.dashboardData?.recentList?.count ?? 0 > 0 {
                return 170
            }
            else {
                return 0
            }
        case 2:
            if self.dashboardData?.topBrands?.count ?? 0 > 0 {
                return 90
            }
            else {
                return 0
            }
        case 3:
            if self.dashboardData?.trendingCategories?.count ?? 0 > 0 {
                return 160
            }
            else {
                return 0
            }
        default:
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 20))
        header.addSubview(titleLabel)
        let viewButton = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: 0, width: 100, height: 20))
        viewButton.setTitleColor(UIColor(named: "primaryRed"), for: .normal)
        viewButton.titleLabel!.font = UIFont.init(name: "Poppins-Regular", size: 16.0)
        
        header.addSubview(viewButton)
        titleLabel.textColor = .black
        titleLabel.font = UIFont.init(name: "Poppins-Regular", size: 16.0)
        titleLabel.text = headerTitles[section]
        viewButton.setTitle(buttonTitles[section], for: .normal)
        viewButton.underline(color: "primaryRed")
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
                return CGFloat.leastNormalMagnitude
            }
        case 1:
            if self.dashboardData?.recentList?.count ?? 0 > 0 {
                return 30
            }
            else {
                return CGFloat.leastNormalMagnitude
            }
        case 2:
            if self.dashboardData?.topBrands?.count ?? 0 > 0 {
                return 30
            }
            else {
                return CGFloat.leastNormalMagnitude
            }
        case 3:
            if self.dashboardData?.trendingCategories?.count ?? 0 > 0  {
                return 30
            }
            else {
                return CGFloat.leastNormalMagnitude
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
    
    @objc func exploreAction(sender: UIButton){
        
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        let indexPath = NSIndexPath(row: row, section: section)
        
        let cell = self.homeTableCollectionCell.cellForItem(at: indexPath as IndexPath) as? TrendingCollectionCell
        self.homeSection4Delegate?.collectionView(collectionviewcell: cell, index: indexPath as IndexPath, sectionTag: sectionTag,didTappedInTableViewCell: self)
    }
    
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
            cell.categoryImgView.image = nil
            if let image = categoryData?.image , !image.isEmpty {
                cell.categoryImgView.setImage(with: image, placeholder: UIImage(named: "rectangle")!)
            }
            else {
                cell.categoryImgView.image = UIImage(named: "rectangle")
            }
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentsCollectionCell", for: indexPath) as! RecentsCollectionCell
            let recentData = self.recentList?[indexPath.item]
            cell.imgView.image = nil
            cell.imageNameLabel.text = recentData?.companyName.getAcronyms().uppercased()
            if let image = recentData?.companyLogo , !image.isEmpty {
                cell.imgView.setImage(with: image, placeholder: UIImage(named: "rectangle")!)
                cell.nameView.isHidden = true
            }
            else {
                cell.imgView.image = UIImage(named: "rectangle")
                cell.nameView.isHidden = false
            }
            cell.nameLabel.text = recentData?.name
            cell.categoryLabel.text = recentData?.companyCategory
            cell.typeLabel.text = recentData?.repetition
            return cell
            
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
            cell.bgView.isHidden = true
            cell.categoryNameLabel.isHidden = true
            let categoryData = self.topBrands?[indexPath.item]
            cell.categoryImgView.image = nil
            cell.imageNameLbl.text = categoryData?.name.getAcronyms().uppercased()
            if let image = categoryData?.image , !image.isEmpty {
                cell.categoryImgView.setImage(with: image, placeholder: UIImage(named: "rectangle")!)
                cell.nameView.isHidden = true
            }
            else {
                cell.categoryImgView.image = UIImage(named: "rectangle")
                cell.nameView.isHidden = false
            }
            
            return cell
            
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionCell", for: indexPath) as! TrendingCollectionCell
            let trendingData = self.trendingCategories?[indexPath.item]
            cell.categoryLabel.text = trendingData?.name
            cell.exploreButton.tag = (indexPath.section * 1000) + indexPath.row
            cell.exploreButton.addTarget(self, action: #selector(exploreAction(sender:)), for: .touchUpInside)
            cell.imgView.image = nil
            if let image = trendingData?.image , !image.isEmpty {
                cell.imgView.setImage(with: image, placeholder: UIImage(named: "rectangle")!)
            }
            else {
                cell.imgView.image = UIImage(named: "rectangle")
            }
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
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2.5) - 20), height: 90)
        case 1:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 1.5) - 10), height: 170)
        case 2:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2.5) - 20), height: 90)
        case 3:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 1.2) - 10), height: 160)
        default:
            return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 10), height: 170)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sectionTag {
        case 0:
            return UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        case 1:
            return UIEdgeInsets(top: 5, left: 11, bottom: 5, right: 11)
        case 2:
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        case 3:
            return UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        default:
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
        
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
            pushToCouponDetail(couponDetail: data,titleString: data.name,isFromCouponTab: false,isHistory:false)
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
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
