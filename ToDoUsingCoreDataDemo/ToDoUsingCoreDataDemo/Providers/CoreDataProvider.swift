//
//  CoreDataProvider.swift
//  ToDoUsingCoreDataDemo
//
//  Created by Shafiq  Ullah on 11/6/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataProvider{
    let persistentContainer : NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    static var preview:CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let viewContext = provider.viewContext
        
        for index in 1..<10{
            let todoItem  = ToDoItem(context: viewContext)
            todoItem.title = "to do item \(index)"
            todoItem.isCompleted = index % 2 == 0 ? true : false
            
        }
        do{
            try viewContext.save()
        }catch{
            print(error)
        }
        
        
        
        
        return provider
    }()
    
    init(inMemory: Bool = false){
        persistentContainer = NSPersistentContainer(name: "ToDoModel")
        
        if inMemory{
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to initialized \(error)")
            }
        }
    }
}
