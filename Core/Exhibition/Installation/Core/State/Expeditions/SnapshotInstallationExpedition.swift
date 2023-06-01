//
//  GenerateInstallationExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import Combine
import Foundation
import MarbleKit

struct SnapshotInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = InstallationEvents.Snapshot
    typealias ExpeditionState = InstallationState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.installation.saveCreativeMarbled(data: event.data, moc: coreDataInstance)
        state.stage = .snapshot
        state.marbledImage = event.image
        GraniteLogger.info("storing snapshot", .expedition, focus: true)
    }
}
