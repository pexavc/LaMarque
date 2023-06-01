//
//  MarqueEvents.swift
//  marble (iOS)
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI

public struct GlassEvents {
    
    public static var glassQueue: DispatchQueue = {
        .init(label: "marble.glass.queue",
              qos: .background,
              autoreleaseFrequency: .workItem)
    }()
    
    public struct Glass: GraniteEvent {
        
        public struct Request: GraniteEvent {
            public enum GlassType {
                case listen
                case player
            }
            let type: GlassType
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            public var beam: GraniteBeamType {
                .rebound
            }
            public var async: DispatchQueue? {
                GlassEvents.glassQueue
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
                GlassEvents.glassQueue
            }
        }
        
        public struct Ping: GraniteEvent {
            let sample: Float
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            
            public var beam: GraniteBeamType {
                .broadcast
            }
        }
    }
}
