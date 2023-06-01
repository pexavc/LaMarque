//
//  MainEvents.swift
//  
//
//  Created by PEXAVC on 12/19/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct MainEvents {
    struct User: GraniteEvent {
        
        struct Prepare: GraniteEvent {}
    }
    struct RequestRoute: GraniteEvent {
        public var route: Route
    }
}
