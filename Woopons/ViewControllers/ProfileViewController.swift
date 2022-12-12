//
//  ProfileViewController.swift
//  Woopons
//
//  Created by harsh on 22/11/22.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var billingDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var profileModel : Profile?
    let myPickerController = UIImagePickerController()
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithTitle(title: "")
        self.title = "Profile"
        self.uploadButton.underline(color: "black5")
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProfileDetails))
        rightBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem  = rightBarButtonItem
        myPickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileDetails()
    }
    
    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        if let button = sender as? UIButton {
            actionSheet.popoverPresentationController?.sourceView = button
            actionSheet.popoverPresentationController?.sourceRect = button.bounds
        }
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.myPickerController.sourceType = UIImagePickerController.SourceType.camera
                self.myPickerController.allowsEditing = true
                self.present(self.myPickerController, animated: true, completion: nil)
            }else{
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.myPickerController.allowsEditing = true
            self.present(self.myPickerController, animated: true, completion: nil)
        }))
      
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.selectedImage = selectedImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.profileImageView.image = selectedImage
            self.uploadImageToServer()
        }
        self.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func saveProfileDetails(){
        if(nameTextField.text!.isEmptyOrWhitespace)() {
            self.showError(message: "Please enter your name")
        }
        
        else if(phoneTextField.text!.isEmptyOrWhitespace()){
            self.showError(message: "Please enter your phone number")
        }
        else {
            self.updateProfile()
        }
    }
    
    @IBAction func upgradeButtonAction(_ sender: UIButton) {
        
    }
    
    func setProfileData() {
        
        if let image = profileModel?.image , !image.isEmpty {
            self.profileImageView.setImage(with: image, placeholder: UIImage(named: "placeholder")!)
        }
        else {
            self.profileImageView.image = UIImage(named: "placeholder")
        }
        self.nameTextField.text = profileModel?.name
        self.emailTextField.text = profileModel?.email
        self.phoneTextField.text = profileModel?.phone
        self.planLabel.text = profileModel?.planName
        self.billingDateLabel.text = "Next billing date \(profileModel?.nextBilling ?? "")"
        self.statusLabel.text = "  \(profileModel?.status ?? "")  "
    }
    
    // MARK: - Api Call's
    
    func getProfileDetails() {
        
        ApiService.getAPIWithoutParameters(urlString: Constants.AppUrls.myProfile, view: self.view) { response in
            
            if let dict = response as? [String:AnyObject] {
                self.profileModel =  Profile.eventWithObject(data: dict)
                self.setProfileData()
            }
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func updateProfile() {
        
        let parameters: [String: Any] = [ "name": self.nameTextField.text ?? "" , "phone":self.phoneTextField.text ?? "" ]
        
        ApiService.postAPIWithHeaderAndParameters(urlString: Constants.AppUrls.updateProfile, view: self.view, jsonString: parameters as [String : AnyObject] ) { response in
            
            self.showError(message: response["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
    
    func uploadImageToServer() {
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.5) ?? Data()
        
        ApiService.uploadImage(urlString: Constants.AppUrls.updateProfile, type: "image", imageKey: "avatar", fileData: imageData, params: [:], view: self.view)
        { response in
            
            self.showError(message: response["message"] as? String ?? "")
            
        }
    failure: { error in
        self.showError(message: error.localizedDescription)
    }
    }
}

