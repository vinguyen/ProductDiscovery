//
//  UIView+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/2/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set(newCornerRadius) {
            layer.cornerRadius = newCornerRadius
        }
    }
}
