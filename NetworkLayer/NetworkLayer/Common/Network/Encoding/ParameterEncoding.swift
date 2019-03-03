//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public typealias Parameters = [String: Any?]

public protocol ParameterEncoding {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public struct URLEncoding {
    public static func encode(urlRequest: inout URLRequest,
                              bodyParameters: Parameters?,
                              urlParameters: Parameters?,
                              urlParamsEncoder: ParameterEncoding.Type = URLParameterEncoder.self,
                              JSONParamsEncoder: ParameterEncoding.Type = JSONParameterEncoder.self) throws {
        do {
            if let urlParameters = urlParameters {
                try urlParamsEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
            }
            
            if let bodyParameters = bodyParameters {
                try JSONParamsEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

public enum NetworkError: Error {
    case missingURL
    case invalidURL(url: URLConvertiable)
    case parametersNil
    case encodingFailed
    
}

