//
//  Profile.swift
//  Woopons
//
//  Created by harsh on 01/12/22.
//

import Foundation

class Profile {
    
    var planId = 0
    var planName = ""
    var stripePlan = ""
    var status = ""
    var nextBilling = ""
    var canceledAt = ""
    var userId = 0
    var name = ""
    var email = ""
    var image = ""
    var phone = ""
    var address = ""
    var dob = ""
    var subStatus = ""
    
    class func eventWithObject(data:[String : AnyObject]) -> Profile {
        
        let profileDetails = Profile()
        if let event = data["data"] as? [String:AnyObject] {
            
            profileDetails.planId = event["id"] as? Int ?? 0
            profileDetails.planName =  event["plan_name"] as? String ?? ""
            profileDetails.status =  event["status"] as? String ?? ""
            profileDetails.nextBilling = event["next_billing"] as? String ?? ""
            profileDetails.canceledAt = event["canceled_at"] as? String ?? ""
            profileDetails.stripePlan = event["stripe_plan"] as? String ?? ""
            
            if let userDetails = event["user"] as? [String:AnyObject] {
                profileDetails.userId = userDetails["id"] as? Int ?? 0
                profileDetails.name =  userDetails["name"] as? String ?? ""
                profileDetails.email =  userDetails["email"] as? String ?? ""
                profileDetails.image = userDetails["avatar"] as? String ?? ""
                profileDetails.phone = userDetails["phone"] as? String ?? ""
                profileDetails.address = userDetails["address"] as? String ?? ""
                profileDetails.dob = userDetails["dob"] as? String ?? ""
                profileDetails.subStatus = userDetails["sub_status"] as? String ?? ""
            }
        }
        return profileDetails
    }
}
