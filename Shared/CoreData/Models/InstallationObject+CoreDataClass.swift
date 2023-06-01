//
//  InstallationObject+CoreDataClass.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//
//

import GraniteUI
import Foundation
import CoreData

public class InstallationObject: NSManagedObject, CoreDataManaged {
    public typealias Model = InstallationObject
    public static var entityName: String {
        "InstallationObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: InstallationObject.entityName,
            in: context) ?? InstallationObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: InstallationObject.entityName)
    }

}
