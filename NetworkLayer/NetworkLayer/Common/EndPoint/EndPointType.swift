//
//  EndPointType.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import UIKit

public enum NetworkEnviroment {
    case production
    case APITestV1
}

public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var enviromentBaseURL:  String          { get }
    var baseURL:            URL             { get }
    var path:               String          { get }
    var httpMethod:         HTTPMethod      { get }
    var headers:            HTTPHeaders?    { get }
    var body:               Parameters?     { get }
    var urlParams:          Parameters?     { get }
}

extension EndPointType {
    
    var enviromentBaseURL: String {
        get {
            switch APIConfig.enviroment {
            case .production:               return APIConfig.productionBaseURL
            case .APITestV1:                return APIConfig.apiTestV1BaseURL
            }
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: enviromentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

}













