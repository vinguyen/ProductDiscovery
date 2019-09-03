//
//  BaseViewModel.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import Alamofire

class BaseViewModel: NSObject {
    var isOffline: Bool {
        if let isReachable = NetworkReachabilityManager()?.isReachable {
            return !isReachable
        }
        return true
    }
}
