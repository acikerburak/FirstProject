//
//  Gift+CoreDataProperties.swift
//  MyFirstProject
//
//  Created by Burak on 12.08.2024.
//
//

import Foundation
import CoreData


extension Gift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gift> {
        return NSFetchRequest<Gift>(entityName: "Gift")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var type: String?
    @NSManaged public var person: Person?

}

extension Gift : Identifiable {

}
