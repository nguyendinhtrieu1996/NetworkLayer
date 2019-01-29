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
    static var tokenHeader       = ["Authorization": ""]
    static var defaultNullValue  = "null"
    static var enviroment        = NetworkEnviroment.production
    
    static func getProductionBaseURLString(with domain: APIDomain = .main) -> String {
        switch domain {
        case .main:
            return "http://api.app.com/api"
        case .checkout:
            return "http://api.app.com/checkout_api"
        case .chat:
            return "http://api.app.com/chat_api"
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


