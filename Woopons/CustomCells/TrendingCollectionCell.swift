//
//  TrendingCollectionCell.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

class TrendingCollectionCell: UICollectionViewCell {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.gradientView.addGradientWithColor(color: .black, color2: .white)
        
    }

}
