//
//  NumberFormatter+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/2/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation

extension NumberFormatter {
    class func localizedFormattedNumber(from number: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

