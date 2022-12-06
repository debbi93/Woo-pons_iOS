//
//  RecentsCollectionCell.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

class RecentsCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var yellowView: RightCornerView!
    @IBOutlet weak var redView: RightCornerView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      // redView.circleRadius = 8
        yellowView.rotate(angle: 180)
       // yellowView.circleRadius = 8
        categoryLabel.rotate(angle: -90)
    }
    
}
