//
//  CoreDataStack.swift
//  Essentials
//
//  Created by Nicolaos Steinhauer on 04/01/2017.
//  Copyright © 2017 Nicolaos Steinhauer. All rights reserved.
//
//  Inspired by the post on https://swifting.io/blog/2016/09/25/25-core-data-in-ios10-nspersistentcontainer/
//

import Foundation
import CoreData

#if os(iOS)
    public final class CoreDataStack {
        public static let shared = CoreDataStack()                         //singleton instance
        
        public static var modelObjectName = ""                             //the filename of the managed object model resource file
        
        var errorHandler: (Error) -> Void = {_ in }
        
        //MARK: - all iOS versions stack
        
        public lazy var viewContext: NSManagedObjectContext = {
            if #available(iOS 10.0, *) {
                return self.persistentContainer.viewContext
            } else {
                let coordinator = self.persistentStoreCoordinator
                var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                context.persistentStoreCoordinator = coordinator
                return context
            }
        }()
        
        public lazy var backgroundContext: NSManagedObjectContext = {
            if #available(iOS 10.0, *) {
                return self.persistentContainer.newBackgroundContext()
            } else {
                let coordinator = self.persistentStoreCoordinator
                var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                context.persistentStoreCoordinator = coordinator
                return context
            }
        }()
        
        public func saveViewContext() {
            save(context: viewContext)
        }
        
        public func saveBackgroundContext() {
            save(context: backgroundContext)
        }
        
        func save(context: NSManagedObjectContext) {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
        //MARK: - >iOS 10.0 Stack
        
        @available(iOS 10.0, *)
        public lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "EDBiOS")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        //MARK: - <iOS 10.0 Stack
        
        @available(iOS 8.0, *)
        private init() {
            //#1
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(mainContextChanged(notification:)),
                                                   name: .NSManagedObjectContextDidSave,
                                                   object: self.viewContext)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(bgContextChanged(notification:)),
                                                   name: .NSManagedObjectContextDidSave,
                                                   object: self.backgroundContext)
        }
        
        @available(iOS 8.0, *)
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @available(iOS 8.0, *)
        public lazy var libraryDirectory: URL = {
            let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
            return urls.first! as URL
        }()
        
        @available(iOS 8.0, *)
        public lazy var managedObjectModel: NSManagedObjectModel = {
            let modelURL = Bundle.main.url(forResource: "EDBiOS", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        
        @available(iOS 8.0, *)
        public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel:
                self.managedObjectModel)
            let url = self.libraryDirectory.appendingPathComponent("EDBiOS.sqlite")
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: url,
                                                   options: [
                                                    NSMigratePersistentStoresAutomaticallyOption: true,
                                                    NSInferMappingModelAutomaticallyOption: true
                    ]
                )
            } catch {
                // Report any error we got.
                NSLog("CoreData error \(error), \(error._userInfo)")
                self.errorHandler(error)
            }
            return coordinator
        }()
        
        @available(iOS 8.0, *)
        @objc func mainContextChanged(notification: NSNotification) {
            backgroundContext.perform { [unowned self] in
                self.backgroundContext.mergeChanges(fromContextDidSave: notification as Notification)
            }
        }
        
        @available(iOS 8.0, *)
        @objc func bgContextChanged(notification: NSNotification) {
            viewContext.perform{ [unowned self] in
                self.viewContext.mergeChanges(fromContextDidSave: notification as Notification)
            }
        }
    }
#endif
