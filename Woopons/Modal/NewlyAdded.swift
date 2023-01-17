//
//  NewlyAdded.swift
//  Woopons
//
//  Created by harsh on 05/12/22.
//

import Foundation

class NewlyAdded {
    
    
    class func eventWithObject(data:[String : AnyObject]) -> [Favorites] {
        
        var value:[Favorites] = []
        
        if let details = data["data"] as? [String:AnyObject],  let coupons = details["favorite"] as? [AnyObject] {
            
            for coupon in coupons {
                let categoryDetails = Favorites()
                categoryDetails.id = coupon["id"] as? Int ?? 0
                categoryDetails.orderId = coupon["order_id"] as? Int ?? 0
                categoryDetails.name = coupon["name"] as? String ?? ""
                categoryDetails.offer = coupon["offer"] as? String ?? ""
                categoryDetails.about = coupon["about"] as? String ?? ""
                categoryDetails.repetition = coupon["repetition"] as? String ?? ""
                categoryDetails.status = coupon["status"] as? Int ?? 0
                categoryDetails.companyName = coupon["company_name"] as? String ?? ""
                categoryDetails.couponCode = coupon["coupon_code"] as? String ?? ""
                categoryDetails.companyCategory = coupon["company_category"] as? String ?? ""
                categoryDetails.companyLogo = coupon["company_logo"] as? String ?? ""
                categoryDetails.companyLocation = coupon["company_location"] as? String ?? ""
                categoryDetails.ratingCount = coupon["rating_count"] as? Int ?? 0
                categoryDetails.ratingAvergae = coupon["rating_avg"] as? Double ?? 0.0
                categoryDetails.isfavorite = coupon["is_favourited"] as? Bool ?? false
                categoryDetails.howToUse = coupon["how_to_use"] as? String ?? ""
                categoryDetails.lat = coupon["latitude"] as? Double ?? 0.0
                categoryDetails.lng = coupon["longitude"] as? Double ?? 0.0
                categoryDetails.businessDescription = coupon["business_description"] as? String ?? ""
                categoryDetails.potential = coupon["potential_customers_to_know"] as? String ?? ""
                categoryDetails.howLongBusiness = coupon["how_long_in_business"] as? String ?? ""
                value.append(categoryDetails)
            }
        }
        
        return value
    }
    
}
