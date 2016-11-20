//
//  CoreDataManager.swift
//  Jetstream
//
//  Created by Andrew Shepard on 12/10/14.
//  Copyright (c) 2014 Andrew Shepard. All rights reserved.
//

import CoreData

public class CoreDataManager {
    
    public static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data stack
    
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    // MARK: - Public
  
    func fetchedResultsController(forEntityName name: String, sortedBy sortDescriptors: [NSSortDescriptor], predicate: NSPredicate! = nil) -> NSFetchedResultsController<NSManagedObject> {
        let managedObjectContext = self.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: name, in: managedObjectContext!)
        
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("error creating frc: \(error)")
        }
        
        return fetchedResultsController;
    }
    
    // MARK: - Private
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let storeType = NSInMemoryStoreType
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = URL.applicationDocumentsDirectory.appendingPathComponent("Jetstream.sqlite")
        
        let options: [String: AnyObject] = [
            NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(value: true)
        ]
        
        do {
           try coordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: options)
        } catch {
            fatalError("Error creating persistent store: \(error)")
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // https://www.andrewcbancroft.com/2015/08/25/sharing-a-core-data-model-with-a-swift-framework/
        let bundle = Bundle(identifier: "org.andyshep.JetstreamKit")!
        let modelURL = bundle.url(forResource: "Jetstream", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
}
