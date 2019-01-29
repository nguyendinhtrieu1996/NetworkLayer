//
//  APIConfig.swift
//  GlobeDr
//
//  Created by MACOS on 9/28/18.
//  Copyright © 2018 GlobeDr. All rights reserved.
//

import Foundation

public class APIConfig {
    public static var requestTimeOut: TimeInterval = 60
    public static var productionBaseURL = "http://api.globedr.com/api/v1"
    public static var apiTestV1BaseURL  = "http://api-test.globedr.com/api/v1/"
    public static var tokenHeader       = ["Authorization": ""]
    public static var defaultNullValue  = "null"
    public static var enviroment        = NetworkEnviroment.production
}



