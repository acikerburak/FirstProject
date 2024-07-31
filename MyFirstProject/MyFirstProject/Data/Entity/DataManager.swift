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
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addPerson(name: String, giftType: String, giftAmount: Int16? = nil) {
        let newPerson = Person(context: context)
        newPerson.name = name
        
        let newGift = Gift(context: context)
        newGift.type = giftType
        newGift.amount = giftAmount ?? 0
        newGift.person = newPerson
        
        saveContext()
    }
    
    func fetchAllPersons() -> [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return []
        }
    }
    
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
