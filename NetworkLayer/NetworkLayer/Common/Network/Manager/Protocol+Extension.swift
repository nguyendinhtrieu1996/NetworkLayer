//
//  Protocol+Extension.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

// MARK: - URLConvertiable

public protocol URLConvertiable {
    func asURL() throws -> URL
}

extension String: URLConvertiable {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw NetworkError.invalidURL(url: self)
        }
        return url
    }
}

extension URL: URLConvertiable {
    public func asURL() throws -> URL {
        return self
    }
}

extension URLComponents: URLConvertiable {
    public func asURL() throws -> URL {
        guard let url = url else {
            throw NetworkError.invalidURL(url: self)
        }
        return url
    }
}

// MARK: - URLRequestConvertable

public protocol URLRequestConvertable {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertable {
    public var urlRequest: URLRequest? {
        return try? asURLRequest()
    }
}

// MARK: -

extension URLRequest {
    public init(url: URLConvertiable, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
