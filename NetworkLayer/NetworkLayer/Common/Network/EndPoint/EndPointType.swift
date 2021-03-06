//
//  EndPointType.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import UIKit

public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var enviromentBaseURL:  String                   { get }
    var baseURL:            URL                      { get }
    var path:               String                   { get }
    var httpMethod:         HTTPMethod               { get }
    var headers:            HTTPHeaders?             { get }
    var body:               Parameters?              { get }
    var urlParams:          Parameters?              { get }
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













