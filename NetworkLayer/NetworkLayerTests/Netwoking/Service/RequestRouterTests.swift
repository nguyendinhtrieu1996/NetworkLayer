//
//  RouterTests.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class RequestRouterTests: XCTestCase {
    private let validURL = URL(string: "http://foodbikeptithcm.xyz")!
    fileprivate lazy var urlRequest = URLRequest(url: validURL)
    fileprivate var sut: NetworkRouter<SampleEndPoint, APIDataResponse>?

    override func setUp() {
        let mockURLSession = MockURLSession()
        let mockDataTask = MockDataTask()
        sut = NetworkRouter<SampleEndPoint, APIDataResponse>.init(session: mockURLSession, task: mockDataTask)
    }

    override func tearDown() {
    }
    
}

// MARK: handleNetworkResponse tests
extension RequestRouterTests {
    func testHandleNetworkResponseWithSuccessCode() {
        sut?.request(endPoint: SampleEndPoint.home, onSuccess: { (response) in
            
        }, onError: {
            
        })
    }
}

