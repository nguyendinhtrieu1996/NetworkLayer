//
//  Router.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
//

import Foundation

protocol NetworkRouterProtocol: class {
    associatedtype ResponseData  : Decodable
    associatedtype CompletionHanler = (APIResponse<ResponseData>) -> Void
    
    func request(endPoint: EndPointType, onSuccess: CompletionHanler, onError: (()->Void)?)
    func cancel()
}

class NetworkRouter<EndPoint: EndPointType, ResponseData: Decodable>: NetworkRouterProtocol {
    private var task: URLSessionTask?
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared, task: URLSessionDataTask? = nil) {
        self.session = session
        self.task = task
    }
    
    func request(endPoint: EndPointType, onSuccess: @escaping CompletionHanler, onError: (()->Void)?) {
        do {
            let request = try RequestBuilder.buildRequest(from: endPoint)
            NetworkLogger.log(request: request)
            
            task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let strongSelf = self, error == nil else {
                    DispatchQueue.main.async {
                        onError?()
                    }
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.mapData(data: data, response: response, onSuccess: onSuccess, onError: onError)
                }
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
                             onSuccess: @escaping CompletionHanler,
                             onError: (()->Void)?) {
        
        guard let response = response as? HTTPURLResponse else {
            onError?()
            return
        }
        NetworkLogger.log(data: data, response: response)
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let apiResponse = parseJSON(data: data) else {
                onError?()
                return
            }
            onSuccess(apiResponse)
            break
        case .failure:
            onError?()
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



