//
//  MockRequestBuilder.swift
//  NetworkLayerTests
//
//  Created by MACOS on 2/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
@testable import NetworkLayer

class MockRequestionBuilder: RequestBuilder {
    static var addHeaderWasCalled = false
    static var configParamsWasCalled = false
    
    override class func buildRequest(from endPoint: EndPointType) throws -> URLRequest {
        return try super.buildRequest(from: endPoint)
    }
    
    override class func addAdditionalHeaders(_ addtionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        addHeaderWasCalled = true
        super.addAdditionalHeaders(addtionalHeaders, request: &request)
    }
    
    override class func configureParameters(bodyParameters: Parameters?,
                                            urlParameters: Parameters?,
                                            request: inout URLRequest) throws {
        configParamsWasCalled = true
        try super.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
    }
}
