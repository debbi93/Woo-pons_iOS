//
//  TopBrandsViewController.swift
//  Woopons
//
//  Created by harsh on 28/11/22.
//

import UIKit

class TopBrandsViewController: UIViewController {
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var errorImage: UIImageView!
    
    var topBrands = [TopBrands]()
    var page = 1
    var contentOffSet = CGFloat()
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        self.title = "Top brands"
        brandsCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTopBrands()
    }
    
    // MARK: - Api Call's
    
    func getTopBrands() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getTopBrands + "\(page)&limit=20", view: self.view) { response in
            
            if let dict = response["data"] as? [String:AnyObject] {
                let data = TopBrands.eventWithObject(data: dict)
                if self.page == 1 {
                    self.topBrands.removeAll()
                }
                if(data.count > 0){
                    self.topBrands.append(contentsOf: data)
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
                self.brandsCollectionView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffSet = self.brandsCollectionView.contentOffset.y;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.brandsCollectionView && (self.topBrands.count) < self.totalCount {
            if ((self.brandsCollectionView.contentOffset.y + self.brandsCollectionView.frame.size.height) >= self.brandsCollectionView.contentSize.height){
                self.page += 1
                getTopBrands()
            }
        }
    }
}


extension TopBrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.bgView.isHidden = true
        cell.categoryNameLabel.isHidden = true
        let categoryData = self.topBrands[indexPath.item]
        cell.categoryImgView.image = nil
        if !categoryData.image.isEmpty {
            cell.categoryImgView.setImage(with: categoryData.image, placeholder: UIImage(named: "placeholder")!)
        }
        else {
            cell.categoryImgView.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = topBrands[indexPath.item]
        self.pushToFavorites(pageTitle: data.name, urlString: "\(Constants.AppUrls.getCouponsFromBrand)\(data.id)?page=")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 20), height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 15, right: 10)
    }
    
}
