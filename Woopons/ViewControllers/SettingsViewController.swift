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
    
    var imagesArr = ["profile","favorites","feedback","terms","privacy","logout"]
    var namesArr = ["Profile","My favorites","Feedback & Suggestions","Terms & Conditions","Privacy policy","Log out"]
    
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
            self.pushToFavorites(pageTitle: "My Favorites", urlString: Constants.AppUrls.getFavorites)
        case 2:
            self.pushToFeedback()
        case 3:
            pushToWebView(title: "Terms & Conditions",url: "https://www.google.co.in/")
            
        case 4:
            self.pushToWebView(title: "Privacy Policy",url: "https://www.google.co.in/")
        case 5:
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "LogoutViewController")
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(myAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
}

