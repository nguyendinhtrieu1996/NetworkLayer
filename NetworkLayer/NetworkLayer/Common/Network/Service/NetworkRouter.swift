//
//  Router.swift
//  NetworkLayer
//
//  Created by MACOS on 10/9/18
//  Copyright © 2018 MACOS. All rights reserved.
//

import Foundation

protocol NetworkRouterProtocol {
    func request(endPoint: EndPointType) -> DataRequest
}

class NetworkRouter<EndPoint: EndPointType>: NetworkRouterProtocol {
    func request(endPoint: EndPointType) -> DataRequest {
        return SessionManager.default.request(
            endPoint.baseURL,
            method: endPoint.httpMethod,
            parameters: endPoint.parameters,
            headers: endPoint.headers)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 400:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
}



