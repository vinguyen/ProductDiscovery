//
//  UITableView+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

extension UITableView: Identifiable {
    
    func dequeueReusableCell<T: UITableViewCell>(withCellClass cellClass: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing:cellClass), for: indexPath) as? T
    }
    
    func register(cellClass: UITableViewCell.Type) {
        register(cell: String(describing: cellClass))
    }
    
    func register(cell: String) {
        let nib = UINib(nibName: cell, bundle: nil)
        register(nib, forCellReuseIdentifier: cell)
    }
    
    func scrollToTop(animated: Bool = true) {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top-30.0)
        setContentOffset(desiredOffset, animated: animated)
    }
}

extension UITableViewCell: Identifiable {}
