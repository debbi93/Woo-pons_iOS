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

//        if let authToken = UserDefaults.standard.string(forKey: "accessToken") {
//            headers["Authorization"] = "Bearer" + " " + authToken
//        }
        headers["Authorization"] = "Bearer" + " " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dvb3BvbnMueGNlbGFuY2V3ZWIuY29tL2FwaS92MS9hdXRoL2xvZ2luIiwiaWF0IjoxNjcwMjU2NzYzLCJuYmYiOjE2NzAyNTY3NjMsImp0aSI6IkN2ZmF2T0J0SGxPZTRhWE4iLCJzdWIiOiIxNiIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.Mo9pgk-mFqf6q9lC1gpYr9rf6GzH-8MTe5xm8EkIPzA"
       

        return headers
    }
}
