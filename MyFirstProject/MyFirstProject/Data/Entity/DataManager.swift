//
//  DataManager.swift
//  MyFirstProject
//
//  Created by Burak on 30.07.2024.
//

import UIKit
import CoreData

class DataManager {
    
    // Singleton
    static let shared = DataManager()
    private init() {}
    
    // Reference to context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Add a new person with a gift
    func addPerson(name: String, giftType: String, amount: Double?) {
        let newPerson = Person(context: context)
        newPerson.name = name
        
        let newGift = Gift(context: context)
        newGift.type = giftType
        newGift.person = newPerson
        
        if let amount = amount {
            newGift.amount = amount
        }
        
        saveContext()
    }
    
    // Fetch all persons
    func fetchAllPersons() -> [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return []
        }
    }
    
    // Update a person's name
    func updatePerson(oldName: String, newName: String) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", oldName)
        do {
            let persons = try context.fetch(request)
            if let personToUpdate = persons.first {
                personToUpdate.name = newName
                saveContext()
            }
        } catch {
            print("Failed to update: \(error.localizedDescription)")
        }
    }
    
    // Delete a person
    func deletePerson(name: String) {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let persons = try context.fetch(request)
            if let personToDelete = persons.first {
                context.delete(personToDelete)
                saveContext()
            }
        } catch {
            print("Failed to delete: \(error.localizedDescription)")
        }
    }
    
    // Save the context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
