//
//  RecentsCollectionCell.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

class RecentsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
