//
//  ResetCouponTableCell.swift
//  Woopons
//
//  Created by harsh on 30/11/22.
//

import UIKit
import MTSlideToOpen

class ResetCouponTableCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var slider: MTSlideToOpenView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.sliderViewTopDistance = 0
         slider.labelText = "Slide To Unlock"
        slider.slidingColor = .clear
        slider.layer.cornerRadius = 20
        slider.textColor = UIColor(named: "yellowText")!
        slider.sliderBackgroundColor = .clear
        slider.thumbnailColor = .clear
        slider.tintColor = .clear
         slider.thumnailImageView.image = UIImage(named: "slider")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
