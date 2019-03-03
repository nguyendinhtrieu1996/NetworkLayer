//
//  URL+Extension.swift
//  NetworkLayer
//
//  Created by MACOS on 1/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

extension URL {
    static func buildURL(with url: URL, urlParameters paramters: [String: Any?]) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !paramters.isEmpty else {
            return url
        }
        urlComponents.queryItems = []
        paramters.forEach { (key, value) in
            let queryItem = URLQueryItem(name: key,
                                         value: (value as? String ?? APIConfig.defaultNullValue).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url
    }
}
