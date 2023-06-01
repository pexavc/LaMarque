//
//  RouterComponent.swift
//  
//
//  Created by PEXAVC on 1/6/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct RouterComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<RouterCenter, RouterState> = .init()
    
    public init() {
//        FirebaseApp.configure()
    }
    
    public var body: some View {
        #if os(iOS)
        MainComponent()
            .statusBar(hidden: true)
            .colorScheme(.dark)
        #else
        MainComponent()
            .colorScheme(.dark)
        #endif
    }
}
