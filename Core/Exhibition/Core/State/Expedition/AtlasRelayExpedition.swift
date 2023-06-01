//
//  AtlasExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import Combine
import MarbleKit
import Foundation

struct AtlasRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Atlas.Request
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        GraniteLogger.info("preparing atlas", .expedition, focus: true)
        state.installationsMarbling += 1;
        state.atlasRunning = true
        state.stage = .marbling
        connection.request(MarbleEvents.Atlas.Request())
        
        if state.installationsMarbling == 1 {
            connection.hear(event: ListenEvents.Stage.init(stage: state.stage))
        }
    }
}

struct AtlasStopRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Atlas.Request.Stop
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
            
        state.installationsMarbling -= 1;
        
        if state.installationsMarbling <= 0 {
            GraniteLogger.info("stopping atlas \(state.installationsMarbling)", .expedition, focus: true)
            connection.request(MarbleEvents.Atlas.Stop())
            state.installationsMarbling = 0
            state.atlasRunning = false
            state.stage = .none
            connection.hear(event: ListenEvents.Stage.init(stage: state.stage))
        }
    }
}

struct AtlasPingRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarbleEvents.Atlas.Ping
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("atlas pinged", .expedition, focus: false)
        connection.hear(event: CanvasEvents.Run())
    }
}
