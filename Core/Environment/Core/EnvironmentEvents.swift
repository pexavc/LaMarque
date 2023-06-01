//
//  ExperienceEvents.swift
//  
//
//  Created by PEXAVC on 12/31/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct EnvironmentEvents {
    struct Boot: GraniteEvent {}
    struct Broadcasts: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    struct Variables: GraniteEvent {}
}
