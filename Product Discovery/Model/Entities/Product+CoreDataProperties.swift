//
//  Product+CoreDataProperties.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var attributeGroups: NSData?
    @NSManaged public var categorieName: String?
    @NSManaged public var discountPrice: Int64
    @NSManaged public var displayName: String?
    @NSManaged public var images: NSData?
    @NSManaged public var price: Int64
    @NSManaged public var sku: String
    @NSManaged public var totalAvailable: Int16
    @NSManaged public var id: Int64

}
