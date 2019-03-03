//
//  RequestBuilder.swift
//  NetworkLayer
//
//  Created by MACOS on 1/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

class RequestBuilder {
    class func buildRequest(from endPoint: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: endPoint.cachePolicy,
                                 timeoutInterval: APIConfig.requestTimeOut)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            addAdditionalHeaders(endPoint.headers, request: &request)
            try configureParameters(bodyParameters: endPoint.body,
                                    urlParameters: endPoint.urlParams,
                                    request: &request)
            
            return request
        } catch {
            throw error
        }
    }
    
    class func addAdditionalHeaders(_ addtionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = addtionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    class func configureParameters(bodyParameters: Parameters?,
                                   urlParameters: Parameters?,
                                   request: inout URLRequest) throws {
        do {
            try URLEncoding.encode(urlRequest: &request,
                                         bodyParameters: bodyParameters,
                                         urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
}
