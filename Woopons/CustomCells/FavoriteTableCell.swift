//
//  FavoriteTableCell.swift
//  Woopons
//
//  Created by harsh on 22/11/22.
//

import UIKit
import Cosmos

class FavoriteTableCell: UITableViewCell {

    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var imageNameLbl: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        couponButton.isHidden = true
        // Configure the view for the selected state
    }
    
}
