//
//  CategoriesViewController.swift
//  Woopons
//
//  Created by harsh on 28/11/22.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var categoryList = [AllCategories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        self.title = "Select Categories"
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.categoryList.removeAll()
    }
    
    // MARK: - Api Call's
    
    func getAllCategories() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.getAllCategories, view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                self.categoryList =  AllCategories.eventWithObject(data: dict)
                if self.categoryList.count > 0 {
                    self.errorImage.isHidden = true
                }
                else {
                    self.errorImage.isHidden = false
                }
                self.categoriesCollectionView.reloadData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let data = categoryList[indexPath.item]
        cell.categoryNameLabel.text = data.name
        cell.categoryImgView.image = nil
        if !data.image.isEmpty {
            cell.categoryImgView.setImage(with: data.image, placeholder: UIImage(named: "rectangle")!)
        }
        else {
            cell.categoryImgView.image = UIImage(named: "rectangle")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = categoryList[indexPath.item]
        self.pushToFavorites(pageTitle: data.name, urlString: "\(Constants.AppUrls.getCouponsFromCategory)\(data.id)?page=")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2.04) - 20), height: 90)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
    
}
