//
//  JSONParameterEncoderTests.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class JSONParameterEncoderTests: XCTestCase {
    private let validURL = URL(string: "http://foodbikeptithcm.xyz")!
    private lazy var urlRequest = URLRequest(url: validURL)
    private let emptyBodyParams: [String: String] = [:]
    private let validBodyParams: [String: Any?] = ["key1": "value1", "key2": nil]
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testEncodeWithEmptyParams() {
        try! JSONParameterEncoder.encode(urlRequest: &urlRequest, with: emptyBodyParams)
        let httpBodyData = urlRequest.httpBody
        let expectData = try! JSONSerialization.data(withJSONObject: emptyBodyParams, options: .prettyPrinted)
        XCTAssertEqual(httpBodyData, expectData)
    }
    
    func testEncodeWithValidParams() {
        try! JSONParameterEncoder.encode(urlRequest: &urlRequest, with: validBodyParams)
        let httpBodyData = urlRequest.httpBody
        let expectData = try! JSONSerialization.data(withJSONObject: validBodyParams, options: .prettyPrinted)
        XCTAssertEqual(httpBodyData, expectData)
    }
    
    func testEncodeWithParamsFail() {
        let params = ["~~": "~|"]
        try! JSONParameterEncoder.encode(urlRequest: &urlRequest, with: params)
        let httpBodyData = urlRequest.httpBody
        let expectData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        XCTAssertEqual(httpBodyData, expectData)
    }
    
    func testEncodeAddContentTypeHeaderField() {
        try! JSONParameterEncoder.encode(urlRequest: &urlRequest, with: emptyBodyParams)
        let header = urlRequest.allHTTPHeaderFields
        let expectHeaderValue = "application/json"
        XCTAssertEqual(expectHeaderValue, header!["Content-Type"])
    }
    
}
