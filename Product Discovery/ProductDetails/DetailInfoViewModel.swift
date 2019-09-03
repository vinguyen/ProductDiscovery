//
//  DetailInfoViewModel.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DetailInfoViewModel: BaseViewModel {
    var productItem = Variable<Product?>(nil)
    init(productItem: Product) {
        super.init()
        self.productItem.value = productItem
    }
}
