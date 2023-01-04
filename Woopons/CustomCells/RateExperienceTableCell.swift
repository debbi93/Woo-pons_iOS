//
//  RateExperienceTableCell.swift
//  Woopons
//
//  Created by harsh on 30/11/22.
//

import UIKit
import Cosmos

class RateExperienceTableCell: UITableViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.fillMode = .full
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
