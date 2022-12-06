//
//  Home.swift
//  Woopons
//
//  Created by harsh on 03/12/22.
//

import Foundation

class Home {
    
    var categoryList : [AllCategories]?
    var recentList : [Favorites]?
    var topBrands : [TopBrands]?
    var trendingCategories : [TrendingCategories]?
    var count = 0
    
    class func eventWithObject(data:[String : AnyObject]) -> Home {
        
        let homeDetails = Home()
        homeDetails.count = data.count
        homeDetails.categoryList =  AllCategories.eventWithObject(data: data)
        homeDetails.recentList =  Favorites.eventWithObject(data: data)
        homeDetails.topBrands =  TopBrands.eventWithObject(data: data)
        homeDetails.trendingCategories =  TrendingCategories.eventWithObject(data: data)
        return homeDetails
    }
    
}
