//
//  ExhibitionState.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum ExhibitionIntent: Equatable {
    case listen
    case add
    case showcase
    case none
}

public enum ExhibitionStage {
    case marbling
    case none
}

public class ExhibitionState: GraniteState {
    var prepared: Bool = false
    var stage: ExhibitionStage = .none
    
    var installationsMarbling: Int = 0
    
    var installations: [Installation] = []
    var arrangement: [[Installation]] = []
    var sharing: Installation? = nil
    var intent: ExhibitionIntent
    var isSharing: Bool {
        self.sharing != nil
    }
    
    var fullScreen: Bool = false
    var globalFrame: CGRect = .init()
    var atlasRunning: Bool = false
    
    var showcaseIndex: Int = 0
    
    public init(_ intent: ExhibitionIntent) {
        self.intent = intent
    }
    public required init() {
        self.intent = .none
    }
}

public class ExhibitionCenter: GraniteCenter<ExhibitionState> {
    let marbleRelay: MarbleRelay = .init()
    let glassRelay: GlassRelay = .init()
    
    //Adding a router to a dependency allows the internal clean
    //system to fire their relay callbacks...
    //TODO: maybe there should be a better way to automate it?
    //
    @GraniteDependency
    var routerDependency: RouterDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetExhibitionExpedition.Discovery(),
            PrepareExhibitionExpedition.Discovery(),
            ShareInstallationExpedition.Discovery(),
            RemoveInstallationExpedition.Discovery(),
            AtlasRelayExpedition.Discovery(),
            AtlasStopRelayExpedition.Discovery(),
            AtlasPingRelayExpedition.Discovery(),
            GlassListenRelayExpedition.Discovery(),
            GlassPlayerRelayExpedition.Discovery(),
            GlassPingRelayExpedition.Discovery(),
            GlassStopRelayExpedition.Discovery(),
            MarbleFilterRelayExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(ExhibitionEvents.Get(), .dependant)
        ]
    }
}
