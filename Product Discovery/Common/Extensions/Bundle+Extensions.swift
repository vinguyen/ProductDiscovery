//
//  Bundle+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation

extension Bundle {
    
    var baseURL: String {
        return infoDictionary?["BaseURL"] as? String ?? "https://listing-stg.services.teko.vn"
    }
    
}
