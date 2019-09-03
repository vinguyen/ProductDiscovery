//
//  NSManagedObject+Extensions.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    static func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(object_getClass(self)!))
    }
    
    static var entityName: String {
        return String(describing: self)
    }
}
