//
//  CouponDetailViewController.swift
//  Woopons
//
//  Created by harsh on 04/12/22.
//

import UIKit

class CouponDetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    
    var titleString = ""
    var couponDetail = Favorites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        self.detailTableView.estimatedRowHeight = 180
        self.detailTableView.rowHeight = UITableView.automaticDimension
        self.setBackButtonWithTitle(title: "")
        detailTableView.register(UINib(nibName: "DescriptionTableCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailTableView.reloadData()
    }
}


extension CouponDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableCell", for: indexPath) as! DescriptionTableCell
        
        cell.imgView.setImage(with: self.couponDetail.companyLogo, placeholder: UIImage(named: "placeholder")!)
        cell.ratingLabel.text = "\(self.couponDetail.ratingAvergae) (\(self.couponDetail.rating)) ratings"
        cell.ratingView.rating = self.couponDetail.ratingAvergae
        cell.nameLabel.text = self.couponDetail.companyName
        cell.locationLabel.text = self.couponDetail.companyLocation
        cell.repititionLabel.text = self.couponDetail.repetition
        cell.uniqueLabel.text = self.couponDetail.offer
        cell.aboutLabel.text = self.couponDetail.about
        cell.howToUseLabel.text = ""
        if self.couponDetail.isfavorite {
            cell.favButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        else {
            cell.favButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
        
        return cell
    }
    
}
