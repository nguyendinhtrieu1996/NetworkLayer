//
//  APIConfig.swift
//  GlobeDr
//
//  Created by MACOS on 9/28/18.
//  Copyright © 2018 GlobeDr. All rights reserved.
//

import Foundation

enum APIDomain: String {
    case chat = ""
}

class APIConfig {
    static var requestTimeOut: TimeInterval = 60
    static var productionBaseURL = "http://api.globedr.com/api/v1"
    static var apiTestV1BaseURL  = "http://api-test.globedr.com/api/v1/"
    static var tokenHeader       = ["Authorization": ""]
    static var defaultNullValue  = "null"
    static var enviroment        = NetworkEnviroment.production
}


