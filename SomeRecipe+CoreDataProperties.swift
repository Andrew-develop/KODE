//
//  SomeRecipe+CoreDataProperties.swift
//  KODE
//
//  Created by Sergio Ramos on 09.06.2021.
//
//

import Foundation
import CoreData


extension SomeRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SomeRecipe> {
        return NSFetchRequest<SomeRecipe>(entityName: "SomeRecipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipeDescription: String?
    @NSManaged public var instructions: String?
    @NSManaged public var lastUpdated: Int32
    @NSManaged public var difficulty: Int32
    @NSManaged public var someImage: NSSet?

}

// MARK: Generated accessors for someImage
extension SomeRecipe {

    @objc(addSomeImageObject:)
    @NSManaged public func addToSomeImage(_ value: SomeImage)

    @objc(removeSomeImageObject:)
    @NSManaged public func removeFromSomeImage(_ value: SomeImage)

    @objc(addSomeImage:)
    @NSManaged public func addToSomeImage(_ values: NSSet)

    @objc(removeSomeImage:)
    @NSManaged public func removeFromSomeImage(_ values: NSSet)

}

extension SomeRecipe : Identifiable {

}
