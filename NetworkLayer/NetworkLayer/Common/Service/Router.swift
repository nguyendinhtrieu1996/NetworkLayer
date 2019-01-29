//
//  Router.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import Foundation

protocol NetworkRouter: class {
    associatedtype ResponseError : Decodable
    associatedtype ResponseData  : Decodable
    associatedtype EndPoint: EndPointType
    associatedtype CompletionHanle = (APIResponse<ResponseData, ResponseError>) -> Void
    
    func request(_ route: EndPoint,
                 _ onSuccess: @escaping (APIResponse<ResponseData, ResponseError>) -> Void,
                 _ onError: (()->Void)?,
                 _ onNoNetwork: (()->Void)?)
    
    func cancel()
    
}

class Router<EndPoint: EndPointType, ResponseData: Decodable, ResponseError: Decodable>: NetworkRouter {
    private var task: URLSessionTask?
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(_ route: EndPoint,
                 _ onSuccess: @escaping (APIResponse<ResponseData, ResponseError>)->Void,
                 _ onError: (()->Void)?,
                 _ onNoNetwork: (()->Void)?) {
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async { onNoNetwork?() }
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    NetworkLogger.log(data: data, response: response)
                    let result = Router<EndPoint, ResponseData, ResponseError>.handleNetworkResponse(response)
                    
                    switch result {
                    case .success:
                        guard let apiResponse = Router<EndPoint, ResponseData, ResponseError>.parseJSON(data: data) else {
                            DispatchQueue.main.async { onError?() }
                            return
                        }
                        DispatchQueue.main.async { onSuccess(apiResponse) }
                        break
                    case .failure:
                        DispatchQueue.main.async { onError?() }
                        break
                    }
                } else {
                    DispatchQueue.main.async { onError?() }
                }
            })
            
            self.task?.resume()
        } catch {
            DispatchQueue.main.async {
                onError?()
            }
        }
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    public static func parseJSON(data: Data?) -> APIResponse<ResponseData, ResponseError>? {
        guard let responseData = data else { return nil }
        
        do {
            let response = try JSONDecoder().decode(APIResponse<ResponseData, ResponseError>.self, from: responseData)
            return response
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {

        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: APIConfig.requestTimeOut)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            addAdditionalHeaders(route.headers, request: &request)
            
            try configureParameters(bodyParameters: route.body, urlParameters: route.urlParams, request: &request)
            
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try ParameterEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ addtionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = addtionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
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



