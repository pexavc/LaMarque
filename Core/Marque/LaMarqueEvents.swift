//
//  MarqueEvents.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

//[CAN REMOVE] dummy model
struct MarqueKitEncodeResult {
    var data: GraniteImage?
}

struct LaMarqueEvents {
    public struct Generate: GraniteEvent {}
    public struct Site: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct AudioTest: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Export: GraniteEvent {}
    public struct Encoding: GraniteEvent {
        let data: MarqueKitEncodeResult
    }
    public struct Decoding: GraniteEvent {
        let path: String
        
        public var behavior: GraniteEventBehavior {
            .quiet
        }
        
        public struct Result: GraniteEvent {
            let installation: DecodedInstallation
            
            var valid: Bool {
                installation.isValid
            }
        }
    }
    public struct Collect: GraniteEvent {}
    public struct Exists: GraniteEvent {}
}
