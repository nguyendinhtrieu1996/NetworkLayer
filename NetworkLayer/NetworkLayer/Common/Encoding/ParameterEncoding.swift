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
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
    public static func encode(urlRequest: inout URLRequest,
                              bodyParameters: Parameters?,
                              urlParameters: Parameters?) throws {
        do {
            if let urlParameters = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            }
            
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
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

