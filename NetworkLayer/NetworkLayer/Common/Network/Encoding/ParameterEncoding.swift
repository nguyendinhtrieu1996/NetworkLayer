//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import UIKit

public typealias Parameters = [String: Any?]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public struct ParameterEncoding {
    public static func encode(urlRequest: inout URLRequest,
                              bodyParameters: Parameters?,
                              urlParameters: Parameters?,
                              urlParamsEncoder: ParameterEncoder.Type = URLParameterEncoder.self,
                              JSONParamsEncoder: ParameterEncoder.Type = JSONParameterEncoder.self) throws {
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

public enum NetworkError: String, Error {
    case parametersNil  = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed"
    case missingURL     = "URL is nil"
}

