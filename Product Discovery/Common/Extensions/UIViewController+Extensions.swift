//
//  UIViewController+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

extension UIViewController: Identifiable {
    func showInfoAlert(_ message: String,
                          title: String? = nil,
                          completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { (action) in
                                            if let handler = completion {
                                                handler()
                                            }
        })
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
