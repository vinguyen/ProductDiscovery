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
    
    var productAttributes = Variable<[ProductAttribute]>([])
    
    init(productItem: Product) {
        super.init()
        productAttributes.value = productItem.listAttributes
    }
}
