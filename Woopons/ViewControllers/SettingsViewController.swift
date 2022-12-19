//
//  SettingsViewController.swift
//  Woopons
//
//  Created by harsh on 21/11/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    var imagesArr = ["profile","password","favorites","feedback","terms","privacy","logout"]
    var namesArr = ["Profile","Change Password","My favorites","Feedback & Suggestions","Terms & Conditions","Privacy policy","Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableView.register(UINib(nibName: "SettingTableCell", bundle: nil), forCellReuseIdentifier: "SettingTableCell")
        self.tabBarController?.title = "Settings"
    }
    
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
        
        cell.contentLbl.text = namesArr[indexPath.row]
        cell.imgView.image = UIImage(named: imagesArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.pushToProfile()
        case 1:
            self.pushToChangePassword()
        case 2:
            self.pushToFavorites(pageTitle: "My Favorites", urlString: Constants.AppUrls.getFavorites)
        case 3:
            self.pushToFeedback()
        case 4:
            pushToWebView(title: "Terms & Conditions",url: Constants.AppUrls.termsUrl)
            
        case 5:
            self.pushToWebView(title: "Privacy Policy",url: Constants.AppUrls.privacyPolicyUrl)
        case 6:
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "LogoutViewController")
            self.presentfromBottomToTop(vc: myAlert)
            
        default:
            break
        }
    }
    
}

