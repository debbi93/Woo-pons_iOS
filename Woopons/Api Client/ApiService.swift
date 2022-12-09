//
//  ApiService.swift
//  Woopons
//
//  Created by harsh on 29/11/22.
//

import Foundation
import Alamofire
import UIKit
import Toast_Swift
import MaterialActivityIndicator


public let SUnKnownError = "Something Went Wrong"
public let SInternetConnection = "Something wrong with internet connection"
let activityIndicator = MaterialActivityIndicatorView()
let currentWindow = UIApplication.shared.currentUIWindow()?.rootViewController

class ApiService {
    
    //MARK: - POST METHOD WITH HEADER AND PARAMETERS -
    
    class func postAPIWithHeaderAndParameters(urlString:String, view:UIView ,jsonString:[String: AnyObject] ,success: @escaping (AnyObject) -> Void,failure: @escaping(NSError)  -> Void) {
        
        let url = Constants.AppUrls.baseUrl + urlString
        print(url)
        if (NetworkReachabilityManager()?.isReachable)!{
            
           view.isUserInteractionEnabled = false
            view.startActivityIndicator()
            
            AF.request(url, method: .post, parameters: jsonString, encoding: JSONEncoding.default, headers: CustomHeaders.apiHeaders()).responseJSON {
                response in
                
               view.isUserInteractionEnabled = true
                view.stopActivityIndicator()
                
                switch(response.result) {
                case .success(_):
                    print(response)
                    if (response.response?.statusCode == 200){
                        if let value = response.value {
                            success(value as AnyObject)
                        }
                    }
                    else {
                        let value = response.value as? [String:Any]
                        if let errorKey = value?["message"] as? String{
                            showError(message:errorKey)
                        }
                    }
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                }
            }
        }
        else {
            showError(message: SInternetConnection)
        }
    }
    
    class func postAPIWithHeaderAndParameters1(urlString:String, view:UIView ,jsonString:[String: AnyObject] ,success: @escaping (AnyObject) -> Void,failure: @escaping(NSError)  -> Void) {
        
        let url = Constants.AppUrls.baseUrl + urlString
        print(url)
        if (NetworkReachabilityManager()?.isReachable)!{
            
           view.isUserInteractionEnabled = false
            
            AF.request(url, method: .post, parameters: jsonString, encoding: JSONEncoding.default, headers: CustomHeaders.apiHeaders()).responseJSON {
                response in
                
               view.isUserInteractionEnabled = true
                
                switch(response.result) {
                case .success(_):
                    print(response)
                    if (response.response?.statusCode == 200){
                        if let value = response.value {
                            success(value as AnyObject)
                        }
                    }
                    else {
                        let value = response.value as? [String:Any]
                        if let errorKey = value?["message"] as? String{
                           // showError(message:errorKey)
                        }
                    }
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                }
            }
        }
        else {
            showError(message: SInternetConnection)
        }
    }
    
    class func getAPIWithoutParameters(urlString:String,view:UIView,success: @escaping (AnyObject) -> Void,failure: @escaping(NSError)  -> Void){
        
        let url = Constants.AppUrls.baseUrl + urlString
        print(url)
        if (NetworkReachabilityManager()?.isReachable)!{
            
           view.isUserInteractionEnabled = false
            view.startActivityIndicator()
            
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: CustomHeaders.apiHeaders()).responseJSON {
                response in
                
               view.isUserInteractionEnabled = true
                view.stopActivityIndicator()
                
                switch(response.result) {
                case .success(_):
                    print(response)
                    if (response.response?.statusCode == 200){
                        if let value = response.value {
                            success(value as AnyObject)
                        }
                    }
                    else {
                        let value = response.value as? [String:Any]
                        if let errorKey = value?["message"] as? String{
                            showError(message:errorKey)
                        }
                    }
                    break
                case .failure(let error):
                    showError(message: error.localizedDescription)
                }
            }
        }
        else {
            showError(message: SInternetConnection)
        }
    }
    
    
     class func uploadImage(urlString:String,type :String,imageKey:String,fileData:Data,params:[String:AnyObject],view:UIView, success: @escaping (AnyObject) -> Void,failure: @escaping(Error)  -> Void) {

         let url = Constants.AppUrls.baseUrl + urlString
         if (NetworkReachabilityManager()?.isReachable)!{
         let img = fileData
         let timeStamp = Date().timeIntervalSince1970 * 1000
         let fileName = "image\(timeStamp).png"
         
         AF.upload(multipartFormData: { (multipartFormData) in
             multipartFormData.append(fileData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
                 for (key, value) in params {
                     multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                 }
             }, to: url)
         .uploadProgress(queue: .main, closure: { progress in
                     //Current upload progress of file
                     print("Upload Progress: \(progress.fractionCompleted)")
                 })
                 .responseJSON(completionHandler: { response in
                     //Do what ever you want to do with response
                     switch(response.result) {
                     case .success(_):
                         print(response)
                         if (response.response?.statusCode == 200){
                             if let value = response.value {
                                 success(value as AnyObject)
                             }
                         }
                         else {
                             let value = response.value as? [String:Any]
                             if let errorKey = value?["message"] as? String{
                                 showError(message:errorKey)
                             }
                         }
                         break
                     case .failure(let error):
                         showError(message: error.localizedDescription)
                     }
                 })
         }
         else {
             showError(message: SInternetConnection)
         }
         }
    
    
    
    class func showError(message:String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = UIColor(named: "primaryRed")!
        ToastManager.shared.style = style
        currentWindow?.view.makeToast(message) // now uses the shared style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }
        let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
        return window
        
    }
}
