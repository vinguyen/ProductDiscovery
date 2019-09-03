//
//  UIImage+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(size: CGSize,
                      gradientPoints: [GradientPoint],
                      gradientDirection: GradientDirection = .vertical,
                      scale: CGFloat = UIScreen.main.scale)
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colorComponents = gradientPoints.compactMap { $0.color.cgColor.components }.flatMap { $0 }
        let locations = gradientPoints.map { $0.location }
        guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(),
                                        colorComponents: colorComponents,
                                        locations: locations,
                                        count: gradientPoints.count) else { return nil }
        
        let startPoint = CGPoint.zero
        let endPoint: CGPoint = {
            switch gradientDirection {
            case .horizontal:
                return CGPoint(x: size.width, y: 0)
            case .vertical:
                return CGPoint(x: 0, y: size.height)
            }
        }()
        
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions())
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: image)
    }
}
