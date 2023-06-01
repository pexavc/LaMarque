//
//  InstallationObject+CoreDataProperties.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//
//

import Foundation
import CoreData


extension InstallationObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstallationObject> {
        return NSFetchRequest<InstallationObject>(entityName: "InstallationObject")
    }

    @NSManaged public var ipfsHash: String
    @NSManaged public var creativeData: Data?
    @NSManaged public var ethTransactionId: String?
    @NSManaged public var creativeMarbledData: Data?
    @NSManaged public var creativeName: String
    @NSManaged public var creativeAuthor: String
    @NSManaged public var isCollected: Bool

}

extension InstallationObject : Identifiable {

}


