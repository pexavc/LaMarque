//
//  MarqueEvents.swift
//  marble (iOS)
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI

public struct MarqueEvents {
    public struct Add: GraniteEvent {
        let path: String
        let signature: String
        
        public struct Site: GraniteEvent {
            let path: String
            let oldSiteID: String
        }
    }
    
    public struct Pin: GraniteEvent {
        let nodes: [MerkleNode]
        let encodedData: Data
        
        public struct Site: GraniteEvent {
            let nodes: [MerkleNode]
            
            public struct Result: GraniteEvent {
                let addHash: Multihash
                let pinHash: Multihash
                
                public var beam: GraniteBeamType {
                    .rebound
                }
            }
        }
        
        public struct Result: GraniteEvent {
            let addHash: Multihash
            let pinHash: Multihash
            let encodedData: Data
            
            public var beam: GraniteBeamType {
                .rebound
            }
        }
    }
}
