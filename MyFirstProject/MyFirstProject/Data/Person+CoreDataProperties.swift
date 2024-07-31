//
//  Person+CoreDataProperties.swift
//  MyFirstProject
//
//  Created by Burak on 30.07.2024.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gifts: NSSet?

}

extension Person {

    @objc(addGiftsObject:)
    @NSManaged public func addToGifts(_ value: Gift)

    @objc(removeGiftsObject:)
    @NSManaged public func removeFromGifts(_ value: Gift)

    @objc(addGifts:)
    @NSManaged public func addToGifts(_ values: NSSet)

    @objc(removeGifts:)
    @NSManaged public func removeFromGifts(_ values: NSSet)

}

extension Person : Identifiable {

}
