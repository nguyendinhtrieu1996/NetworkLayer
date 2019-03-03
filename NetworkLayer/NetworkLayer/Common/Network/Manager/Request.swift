//
//  Request.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

public class Request {
    // MARK: Helper Types
    
    public typealias ProgressHandler = (Progress) -> Void
    
    // MARK: Properties
    
    public let task: URLSessionTask?
    public let session: URLSession?
    public var request: URLRequest?
    public var response: HTTPURLResponse?
    
    // MARK: Lifecycle
    
    init(session: URLSession, task: URLSessionTask) {
        self.session = session
        self.task = task
    }
    
    public func resume() {
        task?.resume()
    }
    
}

// MARK: -

protocol TaskConvertibale {
    func task(session: URLSession, queue: DispatchQueue) -> URLSessionTask
}

// MARK: -

public class DataRequest: Request {
    // MARK: Helper Types
    
    public struct Requestable: TaskConvertibale {
        var urlRequest: URLRequest
        
        func task(session: URLSession, queue: DispatchQueue) -> URLSessionTask {
            return queue.sync {
                session.dataTask(with: urlRequest)
            }
        }
    }
    
    // MARK: Properties
    var progress: Progress?
}
