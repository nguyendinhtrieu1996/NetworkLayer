//
//  RequestBuilderTests.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class RequestBuilderTests: XCTestCase {
    private let validURL = URL(string: "http://foodbikeptithcm.xyz")!
    fileprivate var urlRequest: URLRequest?
    
    override func setUp() {
        urlRequest = URLRequest(url: validURL)
    }

    override func tearDown() {
        MockRequestionBuilder.addHeaderWasCalled = false
        MockRequestionBuilder.configParamsWasCalled = false
    }
    
}

// MARK: Test build request
extension RequestBuilderTests {
    func testBuildRequestCallAddHeaderAndConfigParams() {
        let _ = try! MockRequestionBuilder.buildRequest(from: SampleEndPoint.home)
        XCTAssert(MockRequestionBuilder.configParamsWasCalled)
        XCTAssert(MockRequestionBuilder.addHeaderWasCalled)
    }
    
    func testBuildRequestWithCorrectPath() {
        let request = try! MockRequestionBuilder.buildRequest(from: SampleEndPoint.home)
        guard let urlComponents = request.urlComponents else {
            XCTFail()
            return
        }
        XCTAssertEqual(urlComponents.path, SampleEndPoint.home.path)
    }
    
    func testBuildRequestWithCorrectCachePolicy() {
        let request = try! MockRequestionBuilder.buildRequest(from: SampleEndPoint.home)
        XCTAssertEqual(request.cachePolicy, SampleEndPoint.home.cachePolicy)
    }
    
    func testBuildRequestWithCorrectHTTPMethod() {
        let request = try! MockRequestionBuilder.buildRequest(from: SampleEndPoint.home)
        XCTAssertEqual(request.httpMethod, SampleEndPoint.home.httpMethod.rawValue)
    }
    
    func testBuildRequestWithCorrectHeader() {
        let request = try! MockRequestionBuilder.buildRequest(from: SampleEndPoint.home)
        XCTAssertEqual(request.allHTTPHeaderFields, SampleEndPoint.home.headers)
    }
}

// MARK: - Test add headers
extension RequestBuilderTests {
    func testAddHeaderWithNil() {
        RequestBuilder.addAdditionalHeaders(nil, request: &urlRequest!)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields, nil)
    }
    
    func testAddHeaderWithValidHeader() {
        RequestBuilder.addAdditionalHeaders(SampleEndPoint.home.headers, request: &urlRequest!)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields, SampleEndPoint.home.headers)
    }
}
