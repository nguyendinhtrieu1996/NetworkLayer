//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import UIKit

public enum NetworkError: Error {
    case missingURL
    case invalidURL(url: URLConvertiable)
    case parametersNil
    case encodingFailed
    
}

// MARK: -

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

// MARK: -

public typealias Parameters = [String: Any]

public protocol ParameterEncoding {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

// MARK: -

public struct URLEncoding {
    // MARK: Helper Types
    
    public enum Destination {
        case methodDependent, queryString, httpBody
    }
    
    public enum ArrayEncoding {
        case brackets, noBrackets
        
        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }
    
    public enum BoolEncoding {
        case numeric, literal
        
        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
    
    // MARK: Properties
    
    public static var `default`: URLEncoding { return URLEncoding() }
    public static var methodDependent: URLEncoding { return URLEncoding() }
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }
    private (set) var destination: Destination
    private (set) var arrayEncoding: ArrayEncoding
    private (set) var boolEncoding: BoolEncoding
    
    init(destination: Destination = .methodDependent,
         arrayEncoding: ArrayEncoding = .brackets,
         boolEncoding: BoolEncoding = .numeric) {
        self.destination = destination
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }
    
    public func encode(_ urlRequest: URLRequestConvertable, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else {
            return urlRequest
        }
        
        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? HTTPMethod.get.rawValue),
            encodesParamtersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw NetworkError.encodingFailed
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodeQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "" ) + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodeQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                    forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return URLRequest(url: URL(string: "")!)
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        return []
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    private func query(_ paramters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in paramters.keys.sorted(by: <) {
            if let value = paramters[key] {
                components = queryComponents(fromKey: key, value: value)
            }
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func encodesParamtersInURL(with method: HTTPMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }
        
        switch method {
        case .get, .delete:
            return true
        default:
            return false
        }
    }
    
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
