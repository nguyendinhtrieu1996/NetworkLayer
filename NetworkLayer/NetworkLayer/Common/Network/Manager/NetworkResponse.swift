//
//  NetworkResponse.swift
//  NetworkLayer
//
//  Created by dinhtrieu on 2018. 09. 10..
//  Copyright © 2018. dinhtrieu. All rights reserved.
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
