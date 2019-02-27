//
//  APIConfig.swift
//  GlobeDr
//
//  Created by MACOS on 9/28/18.
//  Copyright © 2018 GlobeDr. All rights reserved.
//

import Foundation

class APIConfig {
    enum NetworkEnviroment {
        case production
        case test
    }
    
    enum APIDomain {
        case main
        case checkout
        case chat
    }
    
    static var requestTimeOut: TimeInterval = 60
    static var tokenHeader       = ["Authorization": "Bearer "]
    static var defaultNullValue  = ""
    static var enviroment        = NetworkEnviroment.production
    
    static func getProductionBaseURLString(with domain: APIDomain = .main) -> String {
        switch domain {
        case .main:
            return "http://api.app.com"
        case .checkout:
            return "http://api.checkout.com"
        case .chat:
            return "http://api.chat.com"
        }
    }
    
    static func geTestBaseURLString(with domain: APIDomain = .main) -> String {
        switch domain {
        case .main:
            return "http://api_test.app.com/api"
        case .checkout:
            return "http://api_test.app.com/checkout_api"
        case .chat:
            return "http://api_test.app.com/chat_api"
        }
    }
    
}


