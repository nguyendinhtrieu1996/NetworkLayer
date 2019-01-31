//
//  URLParameterEncodingTests.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class URLParameterEncodingTests: XCTestCase {
    private let validURL = URL(string: "http://foodbikeptithcm.xyz")!
    private lazy var urlRequest = URLRequest(url: validURL)
    private let emptyParams = [String: String]()
    private let oneParams: [String: Any] = ["key1": "value1"]
    private let twoParams: [String: Any] = ["key1": "value1", "key2": 123]
    private let specialCharacterParam = ["key1": "12@%"]
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testEncodeWithNilURLAndEmptyParams() {
        urlRequest.url = nil
        XCTAssertThrowsError(try URLParameterEncoder.encode(urlRequest: &urlRequest,
                                                            with: emptyParams))
        { error in
            XCTAssertEqual(error as? NetworkError, .missingURL)
        }
    }
    
    func testEncodeWithNilURLAndOneParams() {
        urlRequest.url = nil
        XCTAssertThrowsError(try URLParameterEncoder.encode(urlRequest: &urlRequest,
                                                            with: oneParams))
        { error in
            XCTAssertEqual(error as? NetworkError, .missingURL)
        }
    }
    
    func testEncodeWithValidURLAndEmptyParams() {
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: emptyParams)
        XCTAssertEqual(urlRequest.url, validURL)
    }
    
    func testEncodeWithValidURLAndOneParams() {
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: oneParams)
        let expectURL = URL.buildURL(with: validURL, urlParameters: oneParams)
        XCTAssertEqual(urlRequest.url, expectURL)
    }
    
    func testEncodeWithValidURLAndTwoParams() {
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: twoParams)
        let expectURL = URL.buildURL(with: validURL, urlParameters: twoParams)
        XCTAssertEqual(urlRequest.url, expectURL)
    }
    
    func testEncodeWithNilValueOfParam() {
        let params: [String: Any?] = ["key1": nil]
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: params)
        let expectURL = URL.buildURL(with: validURL, urlParameters: params)
        XCTAssertEqual(urlRequest.url, expectURL)
    }
    
    func testEncodeWithSpecialCharacterParams() {
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: specialCharacterParam)
        let expectURL = URL.buildURL(with: validURL, urlParameters: specialCharacterParam)
        XCTAssertEqual(urlRequest.url, expectURL)
    }
    
    func testEncodeAddHTTPHeaderField() {
        try! URLParameterEncoder.encode(urlRequest: &urlRequest, with: emptyParams)
        let header = urlRequest.allHTTPHeaderFields
        let expectValue = "application/x-www-form-urlencoded; charset=utf-8"
        XCTAssertEqual(header!["Content-Type"]!, expectValue)
    }
    
}
