//
//  DescriptionTableCell.swift
//  Woopons
//
//  Created by harsh on 30/11/22.
//

import UIKit
import Cosmos

class DescriptionTableCell: UITableViewCell {

    @IBOutlet weak var imageNameLbl: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var howToUseLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var uniqueLabel: UILabel!
    @IBOutlet weak var repititionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var potentialDescLbl: UILabel!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var howLongDescLbl: UILabel!
    @IBOutlet weak var howLongLbl: UILabel!
    @IBOutlet weak var potentialLbl: UILabel!
    @IBOutlet weak var aboutCompanyDescLbl: UILabel!
    @IBOutlet weak var aboutCompanyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        directionsButton.underline(color: "textFieldBg")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
