//
//  Installation.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import MarbleKit
import CoreGraphics

public struct Installation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ipfsHash)
    }

    public var ipfsHash: String
    public var creativeData: Data?
    public var creativeMarbledData: Data?
    public var creativeName: String
    public var creativeAuthor: String
    public var ethTransactionId: String?
    public var isCollected: Bool
    public var isPortrait: Bool = false
    public var isObviousPortrait: Bool = false
    public var isLandscape: Bool = false
    public var imageSize: CGSize = .zero
    public var image: MarbleImage = .init()
    
    public init(_ ipfsHash: String,
                name: String,
                author: String,
                creativeData: Data?,
                isCollected: Bool = false) {
        self.ipfsHash = ipfsHash
        self.creativeName = name
        self.creativeAuthor = author
        self.creativeData = creativeData
        self.isCollected = isCollected
        
        image = originalImage
        self.isLandscape = image.width > image.height
        self.isPortrait = image.height > image.width
        self.isObviousPortrait = isPortrait && (image.height/image.width > 1.2)
        self.imageSize = image.size
    }
    
    public init(_ ipfsHash: String,
                data: Data?,
                marbleData: Data?,
                name: String,
                author: String,
                ethTxId: String?,
                isCollected: Bool = false) {
        
        self.ipfsHash = ipfsHash
        self.creativeData = data
        self.creativeMarbledData = marbleData
        self.creativeName = name
        self.creativeAuthor = author
        self.ethTransactionId = ethTxId
        self.isCollected = isCollected
        
        image = originalImage
        self.isLandscape = image.width > image.height
        self.isPortrait = image.height > image.width
        self.isObviousPortrait = isPortrait && (image.height/image.width > 1.2)
        self.imageSize = image.size
    }
    
    public var creativeURL: URL? {
        URL.init(string: creativePath)
    }
    
    public var creativePath: String {
        Installation.gateway+ipfsHash
    }
    
    public static var gateway: String {
        "https://gateway.ipfs.io/ipfs/"
    }
    
    public static var empty: Installation {
        .init("", name: "", author: "", creativeData: nil, isCollected: false)
    }
    
    public var marbledImage: MarbleImage {
        if let data = creativeMarbledData,
           let image = MarbleImage.init(data: data){
            return image
        } else {
            return .init()
        }
    }
    
    public var displayHash: String {
        return String(ipfsHash.prefix(12))
    }
    
    public var marbled: Bool {
        creativeMarbledData != nil
    }
    
    public var originalImage: MarbleImage {
        if let data = creativeData,
           let image = MarbleImage.init(data: data){
            return image
        } else {
            return .init()
        }
    }
    
    public var sharingImage: MarbleImage {
        let encodingType = Services.shared.localStorage.get(GlobalDefaults.Encoding.self)
        
        switch encodingType {
        case GlobalDefaults.Encoding.marbled.value:
            return marbledImage
        case GlobalDefaults.Encoding.original.value:
            return originalImage
        default:
            return originalImage
        }
    }
    
    public var sharingURL: URL? {
        return nil//MarqueKit.writeAssetURL(image: originalImage)
    }
    
    public var signature: String {
        let hash: String = self.ipfsHash
        let creativeID: String = Services.shared.localStorage.get(GlobalDefaults.ExhibitionID, defaultValue: "invalid id")
        let creativeURL: String = Services.shared.localStorage.get(GlobalDefaults.ExhibitionSite, defaultValue: "invalid id")
        return ""//MarqueKit.combine([hash, creativeID, self.creativeAuthor, self.creativeName, creativeURL])
    }
}

public struct DecodedInstallation {
    let hash: String
    let exhibitionId: String
    let creativeAuthor: String
    let creativeName: String
    let creativeURL: String
    let creativeData: Data
    let isValid: Bool
    
    public init(_ parts: [String], data: Data) {
        let isNotValid = parts.count < 4 || parts.filter({ $0.isEmpty }).isNotEmpty
        
        self.isValid = !isNotValid
        self.hash = isNotValid ? "" : String(parts[0])
        self.exhibitionId = isNotValid ? "" : String(parts[1])
        self.creativeAuthor = isNotValid ? "" : String(parts[2])
        self.creativeName = isNotValid ? "" : String(parts[3])
        self.creativeURL = isNotValid ? "" : (parts.count > 4 ? String(parts[4]) : "")
        self.creativeData = data
    }
}
