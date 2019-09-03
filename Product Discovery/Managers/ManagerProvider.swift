//
//  ManagerProvider.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

class ManagerProvider {
    static let sharedInstance: ManagerProvider = {
        return ManagerProvider(
            internalAPIControlManager: InternalAPIControlManagerImpl(enabledCertificatePinning: false),
            dataManager: DataManager()
        )
    }()
    
    
    init(internalAPIControlManager: InternalAPIControlManager, dataManager: DataManager) {
        self.internalAPIControlManager = internalAPIControlManager
        self.dataManager = dataManager
    }
    
    let internalAPIControlManager: InternalAPIControlManager
    let dataManager: DataManager
    
    private (set) lazy var productManager: ProductManager = {
        return ProductManagerImpl(
            internalAPIControlManager: self.internalAPIControlManager,
            dataManager: self.dataManager
        )
    }()
}
