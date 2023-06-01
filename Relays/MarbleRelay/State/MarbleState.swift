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

public class MarbleState: GraniteState {
    let service: MarbleService = .init()
    var atlas: Atlas? = nil
}

public class MarbleCenter: GraniteCenter<MarbleState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AtlasExpedition.Discovery(),
            AtlasStopExpedition.Discovery(),
        ]
    }
}
