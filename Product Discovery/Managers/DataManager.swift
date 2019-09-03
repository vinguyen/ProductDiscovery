//
//  DataManager.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import CoreData
import Sync

class DataManager {
    private (set) var dataStack: DataStack
    
    init(modelName: String = "Product_Discovery", storeType: DataStackStoreType = .sqLite) {
        self.dataStack = DataStack(modelName:modelName, storeType: storeType)
    }
    
    func deleteObject(_ object: NSManagedObject) {
        dataStack.mainContext.delete(object)
        saveContext()
    }
    
    func saveContext() {
        do {
            try dataStack.mainContext.save()
        } catch let error {
            print("Save data failed: \(error) ", "Save_data_failed")
        }
    }
}
