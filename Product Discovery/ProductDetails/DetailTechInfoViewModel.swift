//
//  DetailTechInfoViewModel.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailTechInfoViewModel: BaseViewModel {
    
    var productAttributes = Variable<[JSONDictionary]>([])
    
    init(productItem: Product) {
        super.init()
        if let attributesData = productItem.attributeGroups as Data?,
            let attributes = NSKeyedUnarchiver.unarchiveObject(with: attributesData) as? JSONArray {
            self.productAttributes.value = attributes.compactMap { return ($0 as? JSONDictionary) }
        }
    }
}
