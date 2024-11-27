//
//  PrisestenceController.swift
//  HydrationTracker
//
//  Created by apple on 26/11/24.
//

import Foundation
import CoreData


class PersistenceController {
    static let shared = PersistenceController()
    
    let context: NSManagedObjectContext
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "HydrationTracker")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
