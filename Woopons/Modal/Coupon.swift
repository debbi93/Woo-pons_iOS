//
//  Coupon.swift
//  Woopons
//
//  Created by harsh on 04/12/22.
//

import Foundation

class Coupon {
    
    var history : [Favorites]?
    var favorites : [Favorites]?
    
    class func eventWithObject(data:[String : AnyObject]) -> Coupon {
        
        let couponList = Coupon()
        couponList.history =  History.eventWithObject(data: data)
        couponList.favorites =  NewlyAdded.eventWithObject(data: data)
        return couponList
        
    }
    
}

