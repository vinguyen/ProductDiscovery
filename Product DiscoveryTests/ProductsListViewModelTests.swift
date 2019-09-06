//
//  Product_DiscoveryTests.swift
//  Product DiscoveryTests
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XCTest

@testable import Product_Discovery

class ProductsListViewModelTests: XCTestCase {
    
    var productManager: ProductManagerMock!
    var dataManager: DataManager!
    var viewModel: ProductsListViewModel!

    override func setUp() {
        dataManager = DataManager(modelName: "Product_Discovery", storeType: .inMemory)
        productManager = ProductManagerMock()
        viewModel = ProductsListViewModel(productManager: productManager, dataManager: dataManager)
    }

    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }
    
    func testLoadFirstPage() {
        
    }

}
