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
    
    var hasDiscount: Bool {
        return discountPrice != 0 && discountPrice < price
    }
    
    var formattedDiscountPrice: String {
        return NumberFormatter.localizedFormattedNumber(from: discountPrice) + " đ"
    }
    
    var formattedSalePrice: String {
        return NumberFormatter.localizedFormattedNumber(from: price)
    }
    
    var listImageURLs: [String] {
        if let imagesData = images as Data?,
            let images = NSKeyedUnarchiver.unarchiveObject(with: imagesData) as? JSONArray {
            return images.compactMap { return ($0 as? JSONDictionary)?["url"] as? String }
        }
        return []
    }
    
    var listAttributes: [ProductAttribute] {
        if let attributesData = attributeGroups as Data? {
            do {
                let jsonDecoded = try JSONDecoder().decode([ProductAttribute].self, from: attributesData)
                return jsonDecoded
            } catch {
                return []
            }
        }
        return []
    }
    
    var representImageURL: URL? {
        if let imagesData = images as Data?,
            let images = NSKeyedUnarchiver.unarchiveObject(with: imagesData) as? JSONArray,
            let imageURLString = (images.first as? JSONDictionary)?["url"] as? String,
            let imageURL = URL(string: imageURLString) {
            return imageURL
        }
        return nil
    }

}
