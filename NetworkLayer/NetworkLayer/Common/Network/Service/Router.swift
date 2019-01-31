//
//  Router.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import Foundation

protocol NetworkRouter: class {
    associatedtype ResponseData  : Decodable
    associatedtype EndPoint: EndPointType
    associatedtype CompletionHanler = (APIResponse<ResponseData>) -> Void
    
    func request(endPoint: EndPoint,
                 onSuccess: CompletionHanler,
                 onError: (()->Void)?)
    
    func cancel()
    
}

class Router<EndPoint: EndPointType, ResponseData: Decodable>: NetworkRouter {
    private var task: URLSessionTask?
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(endPoint: EndPoint, onSuccess: @escaping CompletionHanler, onError: (()->Void)?) {
        do {
            let request = try buildRequest(from: endPoint)
            NetworkLogger.log(request: request)
            
            task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let strongSelf = self, error == nil else {
                    DispatchQueue.main.async {
                        onError?()
                    }
                    return
                }
                
                strongSelf.mapData(data: data, response: response, onSuccess: onSuccess, onError: onError)
            })
            
            task?.resume()
        } catch {
            DispatchQueue.main.async {
                onError?()
            }
        }
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func mapData(data: Data?,
                             response: URLResponse?,
                             onSuccess: @escaping (APIResponse<ResponseData>) -> Void,
                             onError: (()->Void)?) {
        guard let response = response as? HTTPURLResponse else {
            DispatchQueue.main.async {
                onError?()
            }
            return
        }
        NetworkLogger.log(data: data, response: response)
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let apiResponse = parseJSON(data: data) else {
                DispatchQueue.main.async {
                    onError?()
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess(apiResponse)
            }
            break
        case .failure:
            DispatchQueue.main.async {
                onError?()
            }
            break
        }
    }
    
    fileprivate func parseJSON(data: Data?) -> APIResponse<ResponseData>? {
        guard let responseData = data else {
            return nil
        }
        
        do {
            let response = try JSONDecoder().decode(APIResponse<ResponseData>.self, from: responseData)
            return response
        } catch {
            return nil
        }
    }
    
    fileprivate func buildRequest(from endPoint: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: endPoint.cachePolicy,
                                 timeoutInterval: APIConfig.requestTimeOut)
        
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            addAdditionalHeaders(endPoint.headers, request: &request)
            try configureParameters(bodyParameters: endPoint.body,
                                    urlParameters: endPoint.urlParams,
                                    request: &request)
            
            return request
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
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try ParameterEncoding.encode(urlRequest: &request,
                                         bodyParameters: bodyParameters,
                                         urlParameters: urlParameters)
        } catch {
            throw error
        }
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



