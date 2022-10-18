//
//  PlanetEntity+CoreDataProperties.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/18/22.
//
//

import Foundation
import CoreData


extension PlanetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanetEntity> {
        return NSFetchRequest<PlanetEntity>(entityName: "PlanetEntity")
    }

    @NSManaged public var planetName: String?
    @NSManaged public var planetUrl: String?

}

extension PlanetEntity : Identifiable {

}
