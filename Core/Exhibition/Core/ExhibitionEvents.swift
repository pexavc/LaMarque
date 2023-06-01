//
//  ExhibitionEvents.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct ExhibitionEvents {
    public struct Get: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Prepare: GraniteEvent {
        let installations: [Installation]
    }
    public struct Remove: GraniteEvent {
        let installation: Installation
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Share: GraniteEvent {
        let installation: Installation
        
        public struct Cancel: GraniteEvent {}
    }
    public struct Atlas {
        public struct Request: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
            
            public struct Stop: GraniteEvent {
                public var behavior: GraniteEventBehavior {
                    .quiet
                }
            }
        }
    }
    public struct Glass {
        public struct Listen: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
        public struct Player: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
        public struct Stop: GraniteEvent {
            public var behavior: GraniteEventBehavior {
                .quiet
            }
        }
    }
}
