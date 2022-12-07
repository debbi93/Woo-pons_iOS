//
//  Coupon.swift
//  Woopons
//
//  Created by harsh on 04/12/22.
//

import Foundation

class Coupon {
    
    var history : [Favorites]?
    var newlyAdded : [Favorites]?
    
    class func eventWithObject(data:[String : AnyObject]) -> Coupon {
        
        let couponList = Coupon()
        couponList.history =  History.eventWithObject(data: data)
        couponList.newlyAdded =  NewlyAdded.eventWithObject(data: data)
        return couponList
        
    }
    
}

