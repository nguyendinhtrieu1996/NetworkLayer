//
//  ParamterEncodingTest.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class ParamterEncodingTest: XCTestCase {
    private let validURL = URL(string: "http://foodbikeptithcm.xyz")!
    private lazy var urlRequest = URLRequest(url: validURL)
    private let emptyURLParams = [String: String]()
    private let emptyBodyParams = [String: String]()
    private let urlParams: [String: Any] = ["key1": "value1", "key2": "value2", "key3": 123]
    private let bodyParams: [String: Any] = ["key1": "123", "key2": 12345, "key3": "123@#!@#%"]
    
    override func setUp() {
    }
    
    override func tearDown() {
        MockURLParametersEncoder.wasCallEncode = false
        MockJSONParamtersEncoder.wasCallEncode = false
    }
    
    func testEncodeWithEmptyURLThrowException() {
        urlRequest.url = nil
        XCTAssertThrowsError(try URLEncoding.encode(urlRequest: &urlRequest,
                                                          bodyParameters: emptyBodyParams,
                                                          urlParameters: emptyURLParams))
        { error in
            XCTAssertEqual(error as? NetworkError, .missingURL)
        }
    }
    
    func testEncodeWithUrlParamsWasCalled() {
        try! URLEncoding.encode(urlRequest: &urlRequest,
                                      bodyParameters: nil,
                                      urlParameters: emptyURLParams,
                                      urlParamsEncoder: MockURLParametersEncoder.self,
                                      JSONParamsEncoder: MockJSONParamtersEncoder.self)
        
        XCTAssertTrue(MockURLParametersEncoder.wasCallEncode)
        XCTAssertFalse(MockJSONParamtersEncoder.wasCallEncode)
    }
    
    func testEncodeWithBodyParamsWasCalled() {
        try! URLEncoding.encode(urlRequest: &urlRequest,
                                      bodyParameters: emptyBodyParams,
                                      urlParameters: nil,
                                      urlParamsEncoder: MockURLParametersEncoder.self,
                                      JSONParamsEncoder: MockJSONParamtersEncoder.self)
        
        XCTAssertFalse(MockURLParametersEncoder.wasCallEncode)
        XCTAssertTrue(MockJSONParamtersEncoder.wasCallEncode)
    }
    
    func testEncodeWithURLAndBodyParamsWasCalled() {
        try! URLEncoding.encode(urlRequest: &urlRequest,
                                      bodyParameters: emptyBodyParams,
                                      urlParameters: emptyURLParams,
                                      urlParamsEncoder: MockURLParametersEncoder.self,
                                      JSONParamsEncoder: MockJSONParamtersEncoder.self)
        
        XCTAssertTrue(MockURLParametersEncoder.wasCallEncode)
        XCTAssertTrue(MockJSONParamtersEncoder.wasCallEncode)
    }
    
    func testEncodeWithURLParamsAndNilBodyConfigCorrect() {
        try! URLEncoding.encode(urlRequest: &urlRequest, bodyParameters: nil, urlParameters: urlParams)
        let expectURL = URL.buildURL(with: validURL, urlParameters: urlParams)
        XCTAssertEqual(urlRequest.url, expectURL)
    }
    
    func testEncodeWithBodyAndNilURLParamsConfigCorrect() {
        try! URLEncoding.encode(urlRequest: &urlRequest, bodyParameters: bodyParams, urlParameters: nil)
        let bodyData = urlRequest.httpBody
        let expectBodyData = try! JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
        XCTAssertEqual(bodyData, expectBodyData)
    }
    
    func testEncodeWithURLParamsAndBodyParamsConfigCorrect() {
        try! URLEncoding.encode(urlRequest: &urlRequest, bodyParameters: bodyParams, urlParameters: urlParams)
        let expectURL = URL.buildURL(with: validURL, urlParameters: urlParams)
        XCTAssertEqual(urlRequest.url, expectURL)
        
        let bodyData = urlRequest.httpBody
        let expectBodyData = try! JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
        XCTAssertEqual(bodyData, expectBodyData)
    }
    
}
