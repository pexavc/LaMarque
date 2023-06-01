//
//  WindowState.swift
//  
//
//  Created by PEXAVC on 12/31/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class WindowState: GraniteState {
    let config: WindowConfig
    
    public init(_ config: WindowConfig) {
        self.config = config
    }
    
    required init() {
        self.config = .none
    }
}

public class WindowCenter: GraniteCenter<WindowState> {
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var behavior: GraniteEventBehavior {
        .passthrough
    }
    
    public override var loggerSymbol: String {
        "🪟"
    }
}
