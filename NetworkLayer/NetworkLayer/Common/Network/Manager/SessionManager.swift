//
//  SessionManager.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

open class SessionManager {
    // mARK: Properties
    
    public static var `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        return SessionManager(confiuration: configuration)
    }()
    
    public let session: URLSession
    let queue = DispatchQueue(label: "\(AppConfig.bundleID)\(UUID().uuidString)")
    
    // MARK: - Lifecycle
    
    private init(confiuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        session = URLSession(configuration: confiuration, delegate: nil, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: Data Request
    open func request(
        _ url: URLConvertiable,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: URLEncoding,
        header: HTTPHeaders? = nil) {
        
    }
    
}
