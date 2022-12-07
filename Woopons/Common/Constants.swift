//
//  Constants.swift
//  Woopons
//
//  Created by Harshit Thakur on 20/11/22.
//

import Foundation

struct Constants {
    
    struct AppUrls {
        static let baseUrl = "https://woopons.xcelanceweb.com/api/v1/"
        static let imageBaseUrl = "https://woopons.xcelanceweb.com/"
        static var login = "auth/login"
        static var myProfile = "user/myaccount"
        static var logout = "logout"
        static var updateProfile = "updateprofile"
        static var forgotPassword = "auth/forgotpassword"
        static var getHomeData = "getdashboardata"
        static var getAllCoupons = "getallcoupons"
        static var getAllCategories = "allcategories"
        static var getAllRecentlyAdded = "getallcoupons?page="
        static var getTopBrands = "topratedbusiness?page="
        static var addReview = "addreview"
        static var addRemoveFavorite = "toggleFavoriteCoupon"
        static var getFavorites = "getfavoriteslist?page="
        static var getTrendingCategory = "topratedcategory?page="
        static var getCouponsFromCategory = "getcoupons/category/"
        static var getCouponsFromBrand = "getcoupons/business/"
        static var getMyCoupons = "getmycoupons"
        static var sendFeedback = "user/feedback"
        
        
        
    }
}
