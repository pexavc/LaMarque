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


public class MarqueState: GraniteState {
    let service: MarqueService = .init()
}

public class MarqueCenter: GraniteCenter<MarqueState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AddMarqueExpedition.Discovery(),
            PinMarqueExpedition.Discovery(),
            AddSiteMarqueExpedition.Discovery(),
            PinSiteMarqueExpedition.Discovery()
        ]
    }
}
