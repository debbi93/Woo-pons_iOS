//
//  RecentlyAddedTableCell.swift
//  Woopons
//
//  Created by harsh on 03/12/22.
//

import UIKit

class RecentlyAddedTableCell: UITableViewCell {

    @IBOutlet weak var imageNameLbl: UILabel!
    @IBOutlet weak var nameView: UIView!
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
      //  redView.circleRadius = 8
        yellowView.rotate(angle: 180)
      //  yellowView.circleRadius = 8
        categoryLabel.rotate(angle: -90)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
