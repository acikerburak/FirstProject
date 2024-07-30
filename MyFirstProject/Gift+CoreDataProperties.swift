//
//  Gift+CoreDataProperties.swift
//  MyFirstProject
//
//  Created by Burak on 30.07.2024.
//
//

import Foundation
import CoreData


extension Gift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gift> {
        return NSFetchRequest<Gift>(entityName: "Gift")
    }

    @NSManaged public var type: String?
    @NSManaged public var amount: Double
    @NSManaged public var person: Person?

}

extension Gift : Identifiable {

}
