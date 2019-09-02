//
//  ProductManager.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import RxSwift
import Sync

protocol ProductManager {
    func fetchProductsList(query: String,
                           visitorId: String,
                           channel: String,
                           terminal: String,
                           page: Int,
                           limit: Int,
                           deleteOld: Bool) -> Observable<Bool>
    func fetchProductDetails(productSKU: String, completion: @escaping (Result<Void>) -> Void)
}

class ProductManagerImpl: ProductManager {
    
    private let internalAPIControlManager: InternalAPIControlManager
    private let dataManager: DataManager
    
    init(internalAPIControlManager: InternalAPIControlManager, dataManager: DataManager) {
        self.internalAPIControlManager = internalAPIControlManager
        self.dataManager = dataManager
    }
    
    func fetchProductsList(query: String,
                           visitorId: String,
                           channel: String,
                           terminal: String,
                           page: Int,
                           limit: Int,
                           deleteOld: Bool) -> Observable<Bool> {
        
        return Observable<Bool>.create { event in
            guard let productListURL = InternalAPIRoute.productsList.url else {
                event.onError(InternalAPIError.failedToConductURLRequest)
                return Disposables.create()
            }
            
            let parameters: [String: Any] = [
                "channel": channel,
                "visitorId": visitorId,
                "terminal": terminal,
                "q": query,
                "_page": page,
                "_limit": limit
            ]
            
            self.internalAPIControlManager.performNonAuthRequest(
                with: productListURL,
                method: .get,
                parameters: parameters,
                headers: nil
            ) { result in
                switch result {
                case .success(let response):
                    if response.code == InternalAPIContants.successCode,
                        let data = response.result as? JSONDictionary,
                        let products = data["products"] as? JSONArray {
                        let patchedContent = products.enumerated().compactMap { (index, productDict) -> JSONDictionary? in
                            guard let productDict = productDict  as? JSONDictionary else { return nil }
                            var patchedProductDict = JSONDictionary()
                            patchedProductDict["id"] = index + (page - 1) * limit
                            patchedProductDict["displayName"] = productDict["name"]
                            patchedProductDict["sku"] = productDict["sku"]
                            patchedProductDict["totalAvailable"] = productDict["totalAvailable"]
                            patchedProductDict["price"] = (productDict["price"] as? JSONDictionary)?["sellPrice"] ?? 0
                            patchedProductDict["images"] = productDict["images"]
                            patchedProductDict["discountPrice"] = ((productDict["promotionPrices"] as? JSONArray)?
                                .first as? JSONDictionary)?["promotionPrice"] ?? 0
                            patchedProductDict["categorieName"] = ((productDict["categories"] as? JSONArray)?
                                .first as? JSONDictionary)?["name"]
                            patchedProductDict["attributeGroups"] = productDict["attributeGroups"]
                            return patchedProductDict
                        }
                        let operations: Sync.OperationOptions = deleteOld ? [.all] : [.insert, .update]
                        
                        Sync.changes(patchedContent,
                                     inEntityNamed: "Product",
                                     dataStack: self.dataManager.dataStack,
                                     operations: operations)
                        { error in
                            if error == nil {
                                if let extraData = response.extra as? JSONDictionary,
                                    let totalItems = extraData["totalItems"] as? Int {
                                    let currentItems = page * limit
                                    event.onNext(currentItems >= totalItems)
                                    event.onCompleted()
                                } else {
                                    event.onNext(true)
                                    event.onCompleted()
                                }
                            } else {
                                event.onError(InternalAPIError.failedToFetchProductsList)
                            }
                        }
                    } else {
                        event.onError(InternalAPIError.failedToFetchProductsList)
                    }
                case .failure(_):
                    event.onError(InternalAPIError.failedToFetchProductsList)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchProductDetails(productSKU: String, completion: @escaping (Result<Void>) -> Void) {
        
    }
}


