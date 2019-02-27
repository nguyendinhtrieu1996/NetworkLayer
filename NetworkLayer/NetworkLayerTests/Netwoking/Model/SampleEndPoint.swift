//
//  EndPoint.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
@testable import NetworkLayer

enum SampleEndPoint {
    case home
}

extension SampleEndPoint: EndPointType {
    var enviromentBaseURL: String {
        switch APIConfig.enviroment {
        case .production:
            return APIConfig.getProductionBaseURLString(with: .main)
        case .test:
            return APIConfig.geTestBaseURLString(with: .main)
        }
    }
    
    var path: String {
        return "/api/home"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var body: Parameters? {
        return nil
    }
    
    var urlParams: Parameters? {
        return nil
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return NSURLRequest.CachePolicy.reloadIgnoringCacheData
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Bearer 1234567890sdkakjsaksaaskajskajs"]
    }
    
}
