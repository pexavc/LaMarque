//
//  GlassEvents.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct ListenEvents {
    public struct Stage: GraniteEvent {
        let stage: ExhibitionStage
    }
    
    public struct Listen: GraniteEvent {
        
        public struct Permissions: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
    }
    
    public struct Stop: GraniteEvent {
    }
    
    public struct Radio: GraniteEvent {
        public struct Begin: GraniteEvent {
            
        }
    }
}
