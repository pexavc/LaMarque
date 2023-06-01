//
//  GlassState.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum ListenStage {
    case listening
    case none
}
public class ListenState: GraniteState {
    var exhibitionStage: ExhibitionStage
    var stage: ListenStage = .none
    var intent: ExhibitionIntent = .none
    var wantsToListen: Bool
    public init(stage: ExhibitionStage, intent: ExhibitionIntent) {
        self.stage = .none
        self.exhibitionStage = .none
        self.intent = intent
        self.wantsToListen = false
    }
    public required init() {
        self.stage = .none
        self.exhibitionStage = .none
        wantsToListen = false
    }
}

public class ListenCenter: GraniteCenter<ListenState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            ListenStageExpedition.Discovery(),
            ListenPermissionsExpedition.Discovery(),
            RadioExpedition.Discovery(),
            StopExpedition.Discovery()
        ]
    }
    
    public override var behavior: GraniteEventBehavior {
        .broadcastable
    }
}
