//
//  MockURLSession.swift
//  NetworkLayerTests
//
//  Created by MACOS on 2/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
    var dataTaskWasCalled = false
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskWasCalled = true
        return dataTask(with: url, completionHandler: completionHandler)
    }

}

class MockDataTask: URLSessionDataTask {
    var resumeWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
        super.resume()
    }
    
}
