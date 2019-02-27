//
//  URLRequest+Extension.swift
//  NetworkLayer
//
//  Created by MACOS on 2/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

extension URLRequest {
    public var urlComponents: NSURLComponents? {
        guard let urlAsString = url?.absoluteString else {
            return nil
        }
        return NSURLComponents(string: urlAsString)
    }
}
