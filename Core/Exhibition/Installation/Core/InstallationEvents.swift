//
//  InstallationEvents.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct InstallationEvents {
    public struct Prepare: GraniteEvent {}
    
    public struct ViewMarble: GraniteEvent {}
    
    public struct Advance: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    
    public struct Snapshot: GraniteEvent {
        var data: Data
        var image: GraniteImage
    }
}
