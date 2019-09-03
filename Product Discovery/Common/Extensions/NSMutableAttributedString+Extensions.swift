//
//  NSMutableAttributedString+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/2/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func setStrikeThrough(`for` text: String, color: UIColor = .gray) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        addAttributes([NSAttributedStringKey.baselineOffset: 0,
                       NSAttributedStringKey.strikethroughStyle:  NSUnderlineStyle.styleSingle.rawValue,
                       NSAttributedStringKey.strikethroughColor: color], range: range)
        return self
    }
    
    @discardableResult func setRegular(`for` text: String, ofSize size: CGFloat) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        setAttributes([.font : UIFont.SFProTextRegular(ofSize: size)], range: range)
        return self
    }
    
    @discardableResult func setSemiBold(`for` text: String, ofSize size: CGFloat) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        setAttributes([.font : UIFont.SFProTextSemiBold(ofSize: size)], range: range)
        return self
    }
    
    @discardableResult func setColor(`for` text: String, color: UIColor) -> NSMutableAttributedString {
        let range = (self.string as NSString).range(of: text)
        setAttributes([.foregroundColor : color], range: range)
        return self
    }
}
