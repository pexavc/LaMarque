//
//  WindowComponent.swift
//  
//
//  Created by PEXAVC on 12/31/20.
//  Copyright (c) 2020 Stoic Collective, LLC.. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct WindowComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<WindowCenter, WindowState> = .init()
    
    public init() {}
    
    public var body: some View {
        switch state.config.kind {
        case .exhibition(let intent):
            ExhibitionComponent(state: .init(intent))
        case .verify(let intent):
            VerifyComponent(state: .init(intent))
        case .settings:
            SettingsComponent()
        default:
            EmptyView.init().hidden()
        }
    }
}

extension GraniteComponent {
    public var showEmptyState: some View {
        Passthrough {
            if self.isDependancyEmpty {
                GraniteEmptyComponent(state: .init(self.emptyText))
                    .payload(self.emptyPayload)
            } else {
                self
            }
        }
    }
}
