//
//  ProductManagerMock.swift
//  Product DiscoveryTests
//
//  Created by vi nguyen on 9/4/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import Product_Discovery

class ProductManagerMock: ProductManager {
    
    typealias FetchProductsListClosure = () -> Observable<Bool>
    var fetchProductsListClosure: FetchProductsListClosure?
    var fetchProductsListWasCalled = false
    
    typealias FetchProductDetailsClosure = (_ productItem: Product) -> Observable<Void>
    var fetchProductDetailsClosure: FetchProductDetailsClosure?
    var fetchProductDetailsWasCalled = false
    
    
    func fetchProductsList(query: String,
                           visitorId: String,
                           channel: String,
                           terminal: String,
                           page: Int,
                           limit: Int,
                           deleteOld: Bool) -> Observable<Bool> {
        
        fetchProductsListWasCalled = true
        
        guard let fetchProductsListClosure = self.fetchProductsListClosure else {
            XCTFail()
            return Observable<Bool>.just(false)
        }
        
        return fetchProductsListClosure()
    }
    
    func fetchProductDetails(productItem: Product) -> Observable<Void> {
        fetchProductDetailsWasCalled = true
        
        guard let fetchProductDetailsClosure = self.fetchProductDetailsClosure else {
            XCTFail()
            return Observable<Void>.just(Void())
        }
        
        return fetchProductDetailsClosure(productItem)
    }
    
}
