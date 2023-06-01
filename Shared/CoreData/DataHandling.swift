//
//  DataHandling.swift
//  
//
//  Created by PEXAVC on 12/23/20.
//

import Foundation
import GraniteUI

extension NSObject {
    public var archived: Data? {
        do {
            return try NSKeyedArchiver
                .archivedData(
                    withRootObject: self,
                    requiringSecureCoding: true)
        } catch let error {
            GraniteLogger.error("failed to archive for core data\n\(error.localizedDescription)\nself:String(describing: self)", .utility)
            return nil
        }
    }
}

public protocol Archiveable: Codable {}
extension Archiveable {
    public var archived: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let error {
            GraniteLogger.error("failed to fetch archived data from core data\n\(error.localizedDescription)\nself:String(describing: self)", .utility)
            return nil
        }
    }
}
