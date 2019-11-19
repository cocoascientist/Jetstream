//
//  CoreDataController.swift
//  Jetstream
//
//  Created by Andrew Shepard on 12/10/14.
//  Copyright (c) 2014 Andrew Shepard. All rights reserved.
//

import CoreData

public class CoreDataController {
    
    // MARK: - Public
    
    public var managedObjectContext: NSManagedObjectContext? = nil
    
    public init() {
        // empty initializer
    }
    
    public lazy var persistentStoreContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName, managedObjectModel: self.managedObjectModel)
        container.persistentStoreDescriptions = [self.persistentStoreDescription]
        
        return container
    }()
    
    // MARK: - Private
    
    private lazy var persistentStoreDescription: NSPersistentStoreDescription = {
        let url = URL.applicationDocumentsDirectory.appendingPathComponent("\(self.modelName).sqlite")
        let description = NSPersistentStoreDescription(url: url)
        
        description.setOption(NSNumber(value: true), forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(NSNumber(value: true), forKey: NSInferMappingModelAutomaticallyOption)
        
        return description
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // https://www.andrewcbancroft.com/2015/08/25/sharing-a-core-data-model-with-a-swift-framework/
        guard let bundle = Bundle(identifier: self.bundleIdentifier) else {
            fatalError("bundle not found")
        }
        
        guard let url = bundle.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("model not found")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("could not load model from url: \(url)")
        }
        
        return model
    }()
    
    private let modelName = "Jetstream"
    private let bundleIdentifier = "com.cocoascientist.JetstreamCore"
}

private extension URL {
    static var applicationDocumentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
}
