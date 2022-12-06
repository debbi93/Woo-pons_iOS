//
//  SettingTableCell.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class SettingTableCell: UITableViewCell {

    
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
