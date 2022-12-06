//
//  HomeTableCell.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

protocol HomeSection1Delegate: AnyObject {
    func collectionView(collectionviewcell: CategoriesCollectionCell?, index: IndexPath,sectionTag:Int, didTappedInTableViewCell: HomeTableCell)
       // other delegate methods that you can define to perform action in viewcontroller
}

protocol HomeSection2Delegate: AnyObject {
       func collectionView(collectionviewcell: RecentsCollectionCell?, index: IndexPath,sectionTag:Int, didTappedInTableViewCell: HomeTableCell)
       // other delegate methods that you can define to perform action in viewcontroller
}

protocol HomeSection4Delegate: AnyObject {
       func collectionView(collectionviewcell: TrendingCollectionCell?, index: IndexPath,sectionTag:Int, didTappedInTableViewCell: HomeTableCell)
       // other delegate methods that you can define to perform action in viewcontroller
}

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var homeTableCollectionCell: UICollectionView!
    
    var sectionTag = -1
    var categories : [AllCategories]?
    var recentList : [Favorites]?
    var topBrands : [TopBrands]?
    var trendingCategories : [TrendingCategories]?
    weak var homeSection1Delegate : HomeSection1Delegate?
    weak var homeSection2Delegate : HomeSection2Delegate?
    weak var homeSection4Delegate : HomeSection4Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeTableCollectionCell.register(UINib(nibName: "CategoriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionCell")
        homeTableCollectionCell.register(UINib(nibName: "RecentsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "RecentsCollectionCell")
        homeTableCollectionCell.register(UINib(nibName: "TrendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
