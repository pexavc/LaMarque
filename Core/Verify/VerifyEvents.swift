//
//  VerifyEvents.swift
//  marble
//
//  Created by PEXAVC on 2/25/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct VerifyEvents {
    public struct Shared: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
}
