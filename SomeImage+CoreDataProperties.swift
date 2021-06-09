//
//  SomeImage+CoreDataProperties.swift
//  KODE
//
//  Created by Sergio Ramos on 09.06.2021.
//
//

import Foundation
import CoreData


extension SomeImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SomeImage> {
        return NSFetchRequest<SomeImage>(entityName: "SomeImage")
    }

    @NSManaged public var name: String?
    @NSManaged public var someRecipe: SomeRecipe?

}

extension SomeImage : Identifiable {

}
