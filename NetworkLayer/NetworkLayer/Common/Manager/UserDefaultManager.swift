//
//  UserDefaultManager.swift
//  NetworkLayer
//
//  Created by MACOS on 1/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

class UserDefaultManager {
    private enum Keys: String {
        case appConfig = "appConfig"
    }
    
    static let shared = UserDefaultManager()
    
}
