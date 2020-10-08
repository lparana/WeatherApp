//
//  CoreDataStorage.swift
//  WeatherApp
//
//  Created by Lara Poveda on 08/10/2020.
//

import Foundation
import CoreData


class CoreDataStorage: NSObject {
    
    static let shared = CoreDataStorage()
    
    func addCity(favCity: FavoritePlace){
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteCity", in: persistentContainer.viewContext)!
        let city = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        
        city.setValue(favCity.name, forKeyPath: "name")
        city.setValue(favCity.coord.lat, forKeyPath: "latitude")
        city.setValue(favCity.coord.lon, forKeyPath: "longitude")
        city.setValue(favCity.id, forKeyPath: "id")
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeCity(id: Int){
        let fetchRequest = NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
        
        do {
            let fetchedValues = try self.persistentContainer.viewContext.fetch(fetchRequest)
            if(!fetchedValues.isEmpty){
                let resultsToDelete = fetchedValues.filter { ($0.value(forKey: "id") as! Int) == id}
                self.persistentContainer.viewContext.delete(resultsToDelete.first!)
                try persistentContainer.viewContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getFavoriteCities()->[NSManagedObject]{
        let fetchRequest = NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
        
        do {
            let fetchedResults = try persistentContainer.viewContext.fetch(fetchRequest)
            if(!fetchedResults.isEmpty){
                return fetchedResults
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
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

    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
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
    
}
