//
//  PrepareInstallationExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine
import Foundation
import MarbleKit

struct PrepareInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = InstallationEvents.Prepare
    typealias ExpeditionState = InstallationState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("preparing", .expedition, focus: true)
        
        switch connection.retrieve(\EnvironmentDependency.exhibition.intent) {
        case .showcase:
            connection.request(InstallationEvents.Advance())
            state.stage = .prepared
            connection.request(InstallationEvents.ViewMarble())
        default:
            if state.installation.marbled {
                state.marbledImage = state.installation.marbledImage
                state.stage = .snapshot
            } else {
                state.stage = .prepared
            }
        }
    }
}

struct ViewMarbleInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = InstallationEvents.ViewMarble
    typealias ExpeditionState = InstallationState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if (state.viewingMarble) {
            connection.request(ExhibitionEvents.Atlas.Request.Stop(), .contact)
        }
        
        GraniteLogger.info("viewMarble", .expedition, focus: true)
        
        state.viewingMarble = !state.viewingMarble
    }
}
