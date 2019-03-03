//
//  APIResponseModel.swift
//  NetworkLayer
//
//  Created by MACOS on 1/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

enum Result<String> {
    case success
    case failure(String)
}

class APIResponse<DataResponse: Decodable>: Decodable  {
    private enum ResponseKeys: String, CodingKey {
        case isSuccess  = "success"
        case message    = "message"
        case data       = "data"
    }
    
    var isSuccess = false
    var message = ""
    var data: DataResponse?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        
        isSuccess = try container.decodeIfPresent(Bool.self, forKey: .isSuccess) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try container.decode(DataResponse.self, forKey: .data)
    }
    
}

class APIDataResponse: Decodable {}

