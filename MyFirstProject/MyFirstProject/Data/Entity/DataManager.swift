//
//  DataManager.swift
//  MyFirstProject
//
//  Created by Burak on 30.07.2024.
//

import UIKit
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MyFirstProject")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func addPerson(name: String, giftType: String? = nil, giftAmount: Int16? = nil, jewelryAmount: Double? = nil) {
        let context = persistentContainer.viewContext
        let newPerson = Person(context: context)
        newPerson.name = name
        newPerson.jewelryAmount = jewelryAmount ?? 0.0

        if let giftType = giftType {
            let newGift = Gift(context: context)
            newGift.type = giftType
            newGift.amount = giftAmount ?? 1
            newGift.person = newPerson
        }
        
        saveContext()
    }
    
    func fetchAllPersons() -> [Person] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func updatePerson(person: Person, name: String, giftType: String? = nil, giftAmount: Int16? = nil) {
        let context = person.managedObjectContext ?? persistentContainer.viewContext
        
        context.performAndWait {
            person.name = name
            if let gift = person.gifts?.anyObject() as? Gift {
                if let giftType = giftType {
                    gift.type = giftType
                }
                if let giftAmount = giftAmount {
                    gift.amount = giftAmount
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func deletePerson(person: Person) {
        if let context = person.managedObjectContext {
            context.delete(person)
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        } else {
            print("Error: person has no associated context.")
        }
    }
}

