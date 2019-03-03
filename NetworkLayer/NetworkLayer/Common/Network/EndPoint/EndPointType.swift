//
//  EndPointType.swift
//  NetworkLayer
//
//  Created by MACOS on 10/9/18
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var enviromentBaseURL:  String                   { get }
    var baseURL:            URL                      { get }
    var path:               String                   { get }
    var httpMethod:         HTTPMethod               { get }
    var headers:            HTTPHeaders?             { get }
    var parameters:         Parameters?              { get }
    var cachePolicy:        NSURLRequest.CachePolicy { get }
}

extension EndPointType {
    var enviromentBaseURL: String {
        switch APIConfig.enviroment {
        case .production:
            return APIConfig.getProductionBaseURLString()
        case .test:
            return APIConfig.geTestBaseURLString()
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: enviromentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var headers: HTTPHeaders? {
        return APIConfig.tokenHeader
    }
    
}













