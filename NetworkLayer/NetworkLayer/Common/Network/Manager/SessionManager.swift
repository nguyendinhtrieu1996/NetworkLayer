//
//  SessionManager.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

open class SessionManager {
    // MARK: Properties
    
    public static var `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        return SessionManager(confiuration: configuration)
    }()
    
    public let session: URLSession
    let queue = DispatchQueue(label: "\(AppConfig.bundleID)\(UUID().uuidString)")
    let delegate: SessionDelegate
    
    // MARK: Lifecycle
    
    private init(confiuration: URLSessionConfiguration = URLSessionConfiguration.default,
                 delegate: SessionDelegate = SessionDelegate()) {
        self.delegate = delegate
        session = URLSession(configuration: confiuration, delegate: delegate, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: Data Request
    
    @discardableResult
    open func request(
        _ url: URLConvertiable,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
        var originalRequest: URLRequest
        
        do {
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return DataRequest()
        }
    }
    
    @discardableResult
    private func request(_ urlRequest: URLRequestConvertable) -> DataRequest {
        var originalRequest: URLRequest?
        
        do {
            originalRequest = try urlRequest.asURLRequest()
            let originalTask = DataRequest.Requestable(urlRequest: originalRequest!)
            let task = originalTask.task(session: session, queue: queue)
            let request = DataRequest(session: session, task: task, originalTask: originalTask)
            
            delegate[task] = request
            
            request.resume()
            return request
        } catch {
            return DataRequest()
        }
    }
    
    private func request(_ urlRequest: URLRequest, failedWith error: Error) {
        
    }
    
}
