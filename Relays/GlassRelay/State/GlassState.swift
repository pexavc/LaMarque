//
//  ClockState.swift
//  
//
//  Created by PEXAVC on 12/19/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import MarbleKit

public class GlassState: GraniteState {
    let service: GlassService = .init()
}

public class GlassCenter: GraniteCenter<GlassState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GlassExpedition.Discovery(),
            GlassStopExpedition.Discovery()
        ]
    }
}
