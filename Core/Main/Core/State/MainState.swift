//
//  MainState.swift
//  
//
//  Created by PEXAVC on 12/19/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import CryptoKit

public enum MainStage {
    case authenticated
    case willAuthenticate
    case none
}
public class MainState: GraniteState {
    var stage: MainStage = .none
    var exhibitionName: String = ""
}

public class MainCenter: GraniteCenter<MainState> {
//    let networkRelay: NetworkRelay = .init()
//    let discussRelay: DiscussRelay = .init()
    @GraniteDependency
    var routerDependency: RouterDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            UserExpedition.Discovery(),
            PrepareUserExpedition.Discovery(),
            RouteExpedition.Discovery()
//            LogoutExpedition.Discovery(),
//            DiscussSetResultExpedition.Discovery(),
//            LoginResultExpedition.Discovery(),
//            LoginAuthCompleteExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(MainEvents.User.Prepare(), .dependant)
        ]
    }
    
    var authState: AuthState {
        routerDependency.authState
    }
}
