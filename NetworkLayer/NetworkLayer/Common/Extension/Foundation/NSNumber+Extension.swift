//
//  NSNumber+Extension.swift
//  NetworkLayer
//
//  Created by MACOS on 3/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
