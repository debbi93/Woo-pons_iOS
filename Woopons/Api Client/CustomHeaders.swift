//
//  CustomHeaders.swift
//  Woopons
//
//  Created by harsh on 29/11/22.
//

import Foundation

import Alamofire

class CustomHeaders {

    class func apiHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/json",
        ]

        if let authToken = UserDefaults.standard.string(forKey: "accessToken") {
            headers["Authorization"] = "Bearer" + " " + authToken
        }
    
        return headers
    }
}
