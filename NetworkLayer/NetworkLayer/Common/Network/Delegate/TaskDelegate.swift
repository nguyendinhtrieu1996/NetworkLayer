//
//  TaskDelegate.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

open class TaskDelegate: NSObject {
    
    // MARK: Properties
    
    public var data: Data?
    public var error: Error?
    private let taskLock = NSLock()
    
    var task: URLSessionTask? {
        set {
            taskLock.lock()
            defer { taskLock.unlock() }
            _task = newValue
        }
        get {
            taskLock.lock()
            defer { taskLock.unlock() }
            return _task
        }
    }
    
    private var _task: URLSessionTask? {
        didSet { reset() }
    }
    
    // MARK: Lifecycle
    
    init(task: URLSessionTask) {
        _task = task
    }
    
    func reset() {
        error = nil
    }
    
}

// MARK: -

class DataTaskDelegate: TaskDelegate {
    
    // MARK: Properties
    
    var dataTask: URLSessionDataTask {
        return task as! URLSessionDataTask
    }
    
    var progress: Progress
    var progressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)?
    private var totalbytesReceived: Int64 = 0
    private var mutableData: Data
    private var expectedContentLength: Int64?
    var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    
    // MARK Lifecycle
    override init(task: URLSessionTask) {
        mutableData = Data()
        progress = Progress(totalUnitCount: 0)
        super.init(task: task)
    }
    
    override func reset() {
        super.reset()
        progress = Progress(totalUnitCount: 0)
        totalbytesReceived = 0
        expectedContentLength = nil
        mutableData = Data()
    }
    
}

// MARK: - URLSessionDataDelegate

extension DataTaskDelegate: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else {
            let bytesRecieved = Int64(data.count)
            totalbytesReceived += bytesRecieved
            let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            
            progress.totalUnitCount = totalBytesExpected
            progress.completedUnitCount = totalbytesReceived
            
            if let progressHandler = progressHandler {
                progressHandler.queue.async {
                    progressHandler.closure(self.progress)
                }
            }
        }
    }
}
