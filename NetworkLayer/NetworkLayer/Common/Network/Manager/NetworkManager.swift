//
//  APIService.swift
//  NetworkLayer
//
//  Created by MACOS on 1/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    lazy var homeAPI = HomeAPIManager()
    lazy var authAPI = AuthAPIManager()
    lazy var orderAPI = OrderAPIManager()
}
