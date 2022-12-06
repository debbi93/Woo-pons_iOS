//
//  TopBrands.swift
//  Woopons
//
//  Created by harsh on 03/12/22.
//


import Foundation

class TopBrands {
    
    var id = 0
    var userId = 0
    var name = ""
    var email = ""
    var emailVerified = ""
    var roleId = ""
    var image = ""
    var phone = ""
    var address = ""
    var businessType = ""
    var businessPhone = ""
    var description = ""
    var businessStatus = 0
    
    class func eventWithObject(data:[String : AnyObject]) -> [TopBrands] {
        
        var value:[TopBrands] = []
        if let events =  data["business"] as? [[String:AnyObject]] {
            for event in events  {
                let brandDetails = TopBrands()
                brandDetails.id = event["id"] as? Int ?? 0
                brandDetails.name = event["name"] as? String ?? ""
                brandDetails.userId = event["user_id"] as? Int ?? 0
                brandDetails.email = event["email"] as? String ?? ""
                brandDetails.emailVerified = event["emailVerified"] as? String ?? ""
                brandDetails.roleId = event["roleId"] as? String ?? ""
                brandDetails.image = event["avatar"] as? String ?? ""
                brandDetails.phone = event["phone"] as? String ?? ""
                brandDetails.address = event["address"] as? String ?? ""
                brandDetails.address = event["address"] as? String ?? ""
                brandDetails.businessType = event["business_type"] as? String ?? ""
                brandDetails.businessPhone = event["business_phone"] as? String ?? ""
                brandDetails.description = event["description"] as? String ?? ""
                brandDetails.businessStatus = event["business_status"] as? Int ?? 0
                value.append(brandDetails)
            }
        }
        
        else {
            if let details = data["data"] as? [String:AnyObject],  let brands = details["business"] as? [AnyObject] {
                
                for brand in brands {
                    let brandDetails = TopBrands()
                    brandDetails.id = brand["id"] as? Int ?? 0
                    brandDetails.name = brand["name"] as? String ?? ""
                    brandDetails.userId = brand["user_id"] as? Int ?? 0
                    brandDetails.email = brand["email"] as? String ?? ""
                    brandDetails.emailVerified = brand["emailVerified"] as? String ?? ""
                    brandDetails.roleId = brand["roleId"] as? String ?? ""
                    brandDetails.image = brand["avatar"] as? String ?? ""
                    brandDetails.phone = brand["phone"] as? String ?? ""
                    brandDetails.address = brand["address"] as? String ?? ""
                    brandDetails.address = brand["address"] as? String ?? ""
                    brandDetails.businessType = brand["business_type"] as? String ?? ""
                    brandDetails.businessPhone = brand["business_phone"] as? String ?? ""
                    brandDetails.description = brand["description"] as? String ?? ""
                    brandDetails.businessStatus = brand["business_status"] as? Int ?? 0
                    value.append(brandDetails)
                }
            }
        }
        
        return value
    }
}
