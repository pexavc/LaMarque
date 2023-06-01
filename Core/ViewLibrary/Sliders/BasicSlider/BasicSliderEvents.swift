//
//  BasicSliderEvents.swift
//  
//
//  Created by PEXAVC on 1/2/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct BasicSliderEvents {
    struct Value: GraniteEvent {
        let data: Double
        let isActive: Bool
    }
}
