//
//  TrendingCategories.swift
//  Woopons
//
//  Created by harsh on 05/12/22.
//

import Foundation

class TrendingCategories {
    
    var id = 0
    var name = ""
    var image = ""
    var description = ""
    
    class func eventWithObject(data:[String : AnyObject]) -> [TrendingCategories] {
        
        var value:[TrendingCategories] = []
     
            if let details = data["data"] as? [String:AnyObject],  let categories = details["trending_categories"] as? [AnyObject] {
               
               for category in categories  {
                   let categoryDetails = TrendingCategories()
                   categoryDetails.id = category["id"] as? Int ?? -1
                   categoryDetails.name = category["name"] as? String ?? ""
                   categoryDetails.image = category["image"] as? String ?? ""
                   categoryDetails.description = category["description"] as? String ?? ""
                   value.append(categoryDetails)
               }
           }
      
        
        return value
    }
}
