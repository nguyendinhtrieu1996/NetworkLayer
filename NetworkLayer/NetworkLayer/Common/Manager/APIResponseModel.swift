//
//  APIResponseModel.swift
//  NetworkLayer
//
//  Created by MACOS on 1/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

private enum ResponseKeys: String, CodingKey {
    case isSuccess  = "success"
    case message    = "message"
    case data       = "data"
    case errors     = "errors"
}

class APIResponse<T1: Decodable, T2: Decodable>: Decodable  {
    var isSuccess = false
    var message = ""
    var data: T1?
    var error: T2?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        
        isSuccess = try container.decodeIfPresent(Bool.self, forKey: .isSuccess) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        
        if isSuccess {
            data = try container.decode(T1.self, forKey: .data)
        } else {
            error = try container.decode(T2.self, forKey: .errors)
        }
    }
    
}

class APIErrorResponse: Decodable {}
class APIDataResponse: Decodable {}
