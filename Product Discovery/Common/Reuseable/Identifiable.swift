//
//  Identifiable.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation

public protocol Identifiable: AnyObject {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
