//
//  Styles.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

struct GradientPoint {
    var location: CGFloat
    var color: UIColor
}

enum GradientDirection {
    case horizontal
    case vertical
}

struct Gradient {
    static func mainThemeGradientPoints(alpha: CGFloat = 1) -> [GradientPoint] {
        return [
            GradientPoint(location: 0.0, color: UIColor(red: 223/255, green: 32/255, blue: 32/255, alpha: alpha)),
            GradientPoint(location: 1.0, color: UIColor(red: 245/255, green: 71/255, blue: 30/255, alpha: alpha))
        ]
    }
    
    private static let gradientImageSize = CGSize(width: 100, height: 100)
    
    static let main: UIImage? = {
        guard let image = UIImage(
            size: gradientImageSize,
            gradientPoints: mainThemeGradientPoints(),
            gradientDirection: .horizontal)
            else {
                return nil
        }
        
        return image.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    }()
}

struct Color {
    static let deepSkyBlue = UIColor(red: 30/255, green: 117/255, blue: 246/255,alpha: 1.0)
}
