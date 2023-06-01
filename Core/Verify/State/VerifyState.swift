//
//  VerifyState.swift
//  marble
//
//  Created by PEXAVC on 2/25/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum VerifyIntent: Equatable, Hashable {
    case check(SharePayload)
    case none
}
public class VerifyState: GraniteState {
    let intent: VerifyIntent
    
    public init(_ intent: VerifyIntent) {
        self.intent = intent
    }
    
    public required init() {
        self.intent = .none
    }
}

public class VerifyCenter: GraniteCenter<VerifyState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            VerifySharedAssetExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(VerifyEvents.Shared())
        ]
    }
}
