//
//  ProductDetailsViewModel.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/2/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import CoreData
import RxCocoa
import RxSwift

class ProductDetailsViewModel: BaseViewModel {
    
    var productName: Driver<String?> { return _productName.asDriver(onErrorJustReturn: nil) }
    var prodcutPrice: Driver<String?> { return _productPrice.asDriver(onErrorJustReturn: nil) }
    var isLoading: Driver<Bool> { return _isLoading.asDriver() }
    var errorMessage: Driver<String?> { return _errorMessage.asDriver(onErrorJustReturn: nil)}
    var imagesURL: Driver<[String]> { return _imagesURL.asDriver(onErrorJustReturn: [])}
    var productCode: Driver<NSMutableAttributedString?> { return _productCode.asDriver(onErrorJustReturn: nil)}
    var shouldHideOutOfStockView: Driver<Bool> { return _shouldHideOutOfStockView.asDriver(onErrorJustReturn: true)}
    var discountPrice: Driver<String?> { return _discountPrice.asDriver(onErrorJustReturn: nil)}
    var salePrice: Driver<NSMutableAttributedString?> { return _salePrice.asDriver(onErrorJustReturn: nil)}
    var precentDiscount: Driver<String?> { return _precentDiscount.asDriver(onErrorJustReturn: nil)}
    
    private let productManager: ProductManager
    private let dataManager: DataManager
    private let disposeBag = DisposeBag()
    private let _productName = BehaviorSubject<String?>(value: nil)
    private let _productPrice = BehaviorSubject<String?>(value: nil)
    private let _isLoading = Variable<Bool>(false)
    private let _errorMessage = BehaviorSubject<String?>(value: nil)
    private let _imagesURL = BehaviorSubject<[String]>(value: [])
    private let _productCode = BehaviorSubject<NSMutableAttributedString?>(value: nil)
    private let _shouldHideOutOfStockView = BehaviorSubject<Bool>(value: true)
    private let _discountPrice = BehaviorSubject<String?>(value: nil)
    private let _salePrice = BehaviorSubject<NSMutableAttributedString?>(value: nil)
    private let _precentDiscount = BehaviorSubject<String?>(value: nil)
    
    init(productManager: ProductManager, dataManager: DataManager, productItem: Product) {
        self.productManager = productManager
        self.dataManager = dataManager
        super.init()
        
        if productItem.attributeGroups != nil {
            updateUI(with: productItem)
        } else {
            _isLoading.value = true
            productManager.fetchProductDetails(productItem: productItem).subscribe(onCompleted: { [weak self] in
                self?._isLoading.value = false
                let productFetchRequest = NSFetchRequest<Product>(entityName: Product.entityName)
                productFetchRequest.predicate = NSPredicate(format: "sku == \(productItem.sku)")
                productFetchRequest.fetchLimit = 1
                productFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                productFetchRequest.returnsObjectsAsFaults = false
                if let objects = try? self?.dataManager.dataStack.mainContext.fetch(productFetchRequest),
                    let object = objects?.first {
                    self?.updateUI(with: object)
                }
            }).disposed(by: disposeBag)
        }
    }
    
    private func updateUI(with productItem: Product) {
        _productName.onNext(productItem.displayName)
        _productPrice.onNext(
            productItem.hasDiscount ? productItem.formattedDiscountPrice : productItem.formattedSalePrice + " đ"
        )
        if let imagesData = productItem.images as Data?,
            let images = NSKeyedUnarchiver.unarchiveObject(with: imagesData) as? JSONArray {
            _imagesURL.onNext(images.compactMap{ return ($0 as? JSONDictionary)?["url"] as? String})
        }
        let productCodeAttributedString = NSMutableAttributedString(
            string: "Mã SP: " + productItem.sku
        )
        productCodeAttributedString
            .setColor(for: productItem.sku, color: Color.deepSkyBlue)
        _productCode.onNext(productCodeAttributedString)
        _shouldHideOutOfStockView.onNext(productItem.totalAvailable > 0)
        
        if productItem.hasDiscount {
            _discountPrice.onNext(productItem.formattedDiscountPrice)
            let salePriceAttributedString = NSMutableAttributedString(
                string: productItem.formattedSalePrice
            )
            salePriceAttributedString
                .setRegular(for: productItem.formattedSalePrice, ofSize: 12)
                .setStrikeThrough(for: productItem.formattedSalePrice)
            _salePrice.onNext(salePriceAttributedString)
            let discountPercent = (productItem.price - productItem.discountPrice) /  productItem.price
            _precentDiscount.onNext("\(discountPercent) %")
        } else {
            _discountPrice.onNext(productItem.formattedSalePrice + " đ")
            _salePrice.onNext(nil)
            _precentDiscount.onNext(nil)
        }
    }
}
