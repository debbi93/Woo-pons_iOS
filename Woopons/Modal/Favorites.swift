//
//  Favorites.swift
//  Woopons
//
//  Created by harsh on 01/12/22.
//

import Foundation

class Favorites {
    
    var id = 0
    var name = ""
    var offer = ""
    var about = ""
    var repetition = ""
    var couponCode = ""
    var status = 0
    var companyName = ""
    var companyCategory = ""
    var companyLogo = ""
    var companyLocation = ""
    var ratingCount = 0
    var ratingAvergae = 0.0
    var isfavorite = false
    var howToUse = ""
    var orderId = 0
    var rating = 0.0
    
    class func eventWithObject(data:[String : AnyObject]) -> [Favorites] {
        
        var value:[Favorites] = []
 
            if let details = data["data"] as? [String:AnyObject],  let coupons = details["coupons"] as? [AnyObject] {
                   
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
                        categoryDetails.howToUse = coupon["how_to_use"] as? String ?? ""
                        categoryDetails.companyLogo = coupon["company_logo"] as? String ?? ""
                        categoryDetails.companyLocation = coupon["company_location"] as? String ?? ""
                        categoryDetails.ratingCount = coupon["rating_count"] as? Int ?? 0
                        categoryDetails.ratingAvergae = coupon["rating_avg"] as? Double ?? 0.0
                        categoryDetails.isfavorite = coupon["is_favourited"] as? Bool ?? false
                        categoryDetails.rating = coupon["rating"] as? Double ?? 0.0
                        value.append(categoryDetails)
                    }
                    }
        
        return value
    }
    
}
