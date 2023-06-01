//
//  GraniteEmptyComponent.swift
//  
//
//  Created by PEXAVC on 1/14/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteEmptyComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteEmptyCenter, GraniteEmptyState> = .init()
    
    public init() {}
    
    public var body: some View {
        GraniteDisclaimerComponent(state:
                                    .init(state.text,
                                          colors: command.center.gradients))
    }
}
