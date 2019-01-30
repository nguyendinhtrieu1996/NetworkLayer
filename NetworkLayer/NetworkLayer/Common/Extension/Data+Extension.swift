//
//  Data+Extension.swift
//  NetworkLayer
//
//  Created by MACOS on 1/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

extension Data {
    func toDictionary() -> [String: Any?]? {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any?]
            return dictionary
        } catch {
            return nil
        }
    }
}
