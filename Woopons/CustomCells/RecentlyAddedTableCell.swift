//
//  RecentlyAddedTableCell.swift
//  Woopons
//
//  Created by harsh on 03/12/22.
//

import UIKit

class RecentlyAddedTableCell: UITableViewCell {

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
