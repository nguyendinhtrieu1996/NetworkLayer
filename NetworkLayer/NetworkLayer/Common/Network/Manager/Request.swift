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
    
    enum RequestTask {
        case data(TaskConvertible?, URLSessionTask)
    }
    
    // MARK: Properties
    
    public var task: URLSessionTask?
    public var session: URLSession?
    
    public var request: URLRequest? {
        return task?.originalRequest
    }
    
    public var response: HTTPURLResponse?
    public var originalTask: TaskConvertible?
    private var taskDelegate: TaskDelegate
    private var taskDelegateLock = NSLock()
    
    open internal(set) var delegate: TaskDelegate {
        get {
            taskDelegateLock.lock()
            defer { taskDelegateLock.unlock() }
            return taskDelegate
        }
        set {
            taskDelegateLock.lock()
            defer { taskDelegateLock.unlock() }
            taskDelegate = newValue
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        taskDelegate = TaskDelegate(task: URLSessionTask.init())
    }
    
    init(session: URLSession, requestTask: RequestTask) {
        self.session = session
        
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        
        taskDelegate = DataTaskDelegate(task: task)
    }
    
    public func resume() {
        task?.resume()
    }
    
}

// MARK: -

public protocol TaskConvertible {
    func task(session: URLSession, queue: DispatchQueue) -> URLSessionTask
}

// MARK: -

public class DataRequest: Request {
    // MARK: Helper Types
    
    public struct Requestable: TaskConvertible {
        var urlRequest: URLRequest
        
        public func task(session: URLSession, queue: DispatchQueue) -> URLSessionTask {
            return queue.sync {
                session.dataTask(with: urlRequest)
            }
        }
    }
    
    // MARK: Properties
    
    var dataDelegate: DataTaskDelegate? {
        return delegate as? DataTaskDelegate
    }
    
    var progress: Progress? {
        return dataDelegate?.progress
    }
    
}
