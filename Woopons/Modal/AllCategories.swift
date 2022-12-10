//
//  AllCategories.swift
//  Woopons
//
//  Created by harsh on 01/12/22.
//

import Foundation

class AllCategories {
    
    var id = 0
    var name = ""
    var image = ""
    var trendingImage = ""
    var description = ""
    
    class func eventWithObject(data:[String : AnyObject]) -> [AllCategories] {
        
        var value:[AllCategories] = []
        if let categories =  data["data"] as? [[String:AnyObject]] {
            for category in categories  {
                let categoryDetails = AllCategories()
                categoryDetails.id = category["id"] as? Int ?? -1
                categoryDetails.name = category["name"] as? String ?? ""
                categoryDetails.image = category["image"] as? String ?? ""
                categoryDetails.trendingImage = category["trending_image"] as? String ?? ""
                categoryDetails.description = category["description"] as? String ?? ""
                value.append(categoryDetails)
            }
        }
        
        else if let details = data["data"] as? [String:AnyObject],  let categories = details["categories"] as? [AnyObject] {
            
            for category in categories  {
                let categoryDetails = AllCategories()
                categoryDetails.id = category["id"] as? Int ?? -1
                categoryDetails.name = category["name"] as? String ?? ""
                categoryDetails.image = category["image"] as? String ?? ""
                categoryDetails.trendingImage = category["trending_image"] as? String ?? ""
                categoryDetails.description = category["description"] as? String ?? ""
                value.append(categoryDetails)
            }
        }
  
            return value
        }
    
}
