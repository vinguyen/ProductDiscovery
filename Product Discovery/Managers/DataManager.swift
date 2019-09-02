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
    
    func insertNew<Object: NSManagedObject>(_ type: Object.Type) -> Object {
        let entityName = NSStringFromClass(object_getClass(type)!)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                               into: dataStack.mainContext) as? Object else {
                                                                fatalError("Could not insert entity \(entityName)")
        }
        return entity
    }
    
    func fetchFirst<Object: NSManagedObject>(_ type: Object.Type, predicate: NSPredicate? = nil) -> Object? {
        var result: Object? = nil
        let request = Object.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        
        if let objects = try? dataStack.mainContext.fetch(request) as? [Object],
            let object = objects?.first {
            result = object
        }
        
        return result
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
