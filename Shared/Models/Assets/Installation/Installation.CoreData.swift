//
//  Installation.CoreData.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import CoreData
import GraniteUI

extension NSManagedObjectContext {
    func save(_ installation: Installation) {
        self.performAndWait {
            do {
                let object = InstallationObject.init(context: self)
                installation.apply(to: object)
                
                try self.save()
            } catch let error {
                GraniteLogger.info("something went wrong, saving installation\n\(error)", .expedition, focus: true)
            }
        }
    }
    
    func get<T: CoreDataManaged>(_ request: NSFetchRequest<T>) -> [T]  {
        
        let result = self.performAndWaitPlease {
            (try? self.fetch(request)) ?? []
        }
        
        return result
    }
}

extension NSManagedObjectContext {
    func performAndWaitPlease<T>(_ block: () throws -> T) rethrows -> T {
        return try _performAndWaitHelper(
            fn: performAndWait, execute: block, rescue: { throw $0 }
        )
    }

    /// Helper function for convincing the type checker that
    /// the rethrows invariant holds for performAndWait.
    ///
    /// Source: https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249
    private func _performAndWaitHelper<T>(
        fn: (() -> Void) -> Void,
        execute work: () throws -> T,
        rescue: ((Error) throws -> (T))) rethrows -> T
    {
        var result: T?
        var error: Error?
        withoutActuallyEscaping(work) { _work in
            fn {
                do {
                    result = try _work()
                } catch let e {
                    error = e
                }
            }
        }
        if let e = error {
            return try rescue(e)
        } else {
            return result!
        }
    }
}


extension Installation {
    public func apply(to installation: InstallationObject) {
        installation.ipfsHash = self.ipfsHash
        installation.creativeData = self.creativeData
        installation.creativeMarbledData = self.creativeMarbledData
        installation.creativeName = self.creativeName
        installation.creativeAuthor = self.creativeAuthor
        installation.ethTransactionId = self.ethTransactionId
        installation.isCollected = self.isCollected
    }
    
    public static func getObjectRequest(id: String? = nil) -> NSFetchRequest<InstallationObject> {
        let request: NSFetchRequest = InstallationObject.fetchRequest()
        
        if let ipfsId = id {
            request.predicate = NSPredicate(format: "(ipfsHash == %@)",
                                            ipfsId)
        }

        return request
    }
    
    public func saveCreativeMarbled(data: Data,
                                    moc: NSManagedObjectContext) {
        
        
        let objects = moc.get(Installation.getObjectRequest(id: self.ipfsHash))
        
        moc.performAndWait {
            let target = objects.first
            target?.creativeMarbledData = data
            try? moc.save()
        }
    }
    
    public func remove(moc: NSManagedObjectContext) {
        let objects = moc.get(Installation.getObjectRequest(id: self.ipfsHash))
        moc.performAndWait {
            guard let target = objects.first else { return }
            moc.delete(target)
            try? moc.save()
        }
    }
}

extension InstallationObject {
    var asSelf: Installation {
        .init(self.ipfsHash,
              data: self.creativeData,
              marbleData: self.creativeMarbledData,
              name: self.creativeName,
              author: self.creativeAuthor,
              ethTxId: self.ethTransactionId,
              isCollected: self.isCollected)
    }
}

//extension Quote {
//    public func getObjectRequest() -> NSFetchRequest<QuoteObject> {
//        let request: NSFetchRequest = QuoteObject.fetchRequest()
//        request.predicate = NSPredicate(format: "(ticker == %@) AND (name == %@)",
//                                        self.ticker,
//                                        self.name)
//        
//        return request
//    }
//    
//    public func getObject(moc: NSManagedObjectContext,
//                          _ completion: @escaping((QuoteObject?) -> Void)){
//        
//        let request: NSFetchRequest = self.getObjectRequest()
//        
//        moc.performAndWait {
//            completion(try? moc.fetch(request).first)
//        }
//    }
//}
//
//extension QuoteObject {
//    public var asQuote: Quote {
//        var quote: Quote = .init(ticker: self.ticker,
//                              securityType: SecurityType(rawValue: self.securityType) ?? .unassigned,
//                              exchangeName: self.exchangeName,
//                              name: self.name,
//                              securities: self.securities.compactMap { $0.asSecurity })
//        
//        let models = (self.tonalModel?.compactMap( { $0.asToneFromQuote(quote) }) ?? []).sorted(by: { $0.date.compare($1.date) == .orderedDescending })
//        
//        quote.models = models
//        return quote
//    }
//    
//    public func contains(security: Security) -> Bool {
//        return self.ticker == security.ticker &&
//            self.name == security.name &&
//            self.securityType == security.securityType.rawValue
//    }
//}
