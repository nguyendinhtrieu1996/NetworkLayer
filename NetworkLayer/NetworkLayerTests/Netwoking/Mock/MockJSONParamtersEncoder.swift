//
//  MockJSONParamtersEncoder.swift
//  NetworkLayerTests
//
//  Created by MACOS on 1/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
@testable import NetworkLayer

class MockJSONParamtersEncoder: ParameterEncoding {
    static var wasCallEncode = false
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        wasCallEncode = true
    }
    
}
