//
//  NetworkResponse.swift
//  NetworkLayer
//
//  Created by MACOS on 10/9/18
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first"
    case badRequest = "Bad Request"
    case outdated = "The url you request is outdated"
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
    case noNetwork = "Please check you connection"
}
