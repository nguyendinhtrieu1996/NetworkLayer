//
//  SessionDelegate.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

open class SessionDelegate: NSObject {
    
    var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    
    // MARK: Properties
    
    private var requests: [Int: Request] = [:]
    private let lock = NSLock()
    
    open subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }
    
}

// MARK: - URLSessionTaskDelegate

extension SessionDelegate: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = self.dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }
}
