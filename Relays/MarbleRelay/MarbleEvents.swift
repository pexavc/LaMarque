//
//  MarqueEvents.swift
//  marble (iOS)
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI

public struct MarbleEvents {
    public static var atlasQueue: DispatchQueue = {
        .init(label: "marble.atlas.queue",
              qos: .background,
              attributes: [ .concurrent ],
              autoreleaseFrequency: .workItem)
    }()
    
    public struct Atlas: GraniteEvent {
        
        public struct Request: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            public var beam: GraniteBeamType {
                .rebound
            }
            public var async: DispatchQueue? {
                MarbleEvents.atlasQueue
            }
        }
        
        public struct Stop: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            public var beam: GraniteBeamType {
                .rebound
            }
            public var async: DispatchQueue? {
                MarbleEvents.atlasQueue
            }
        }
        
        public struct Ping: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            
            public var beam: GraniteBeamType {
                .broadcast
            }
            public var async: DispatchQueue? {
                MarbleEvents.atlasQueue
            }
        }
    }
}
