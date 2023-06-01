//
//  GlassExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//
import GraniteUI
import Combine
import MarbleKit
import Foundation
import GlassKit

struct GlassExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GlassEvents.Glass.Request
    typealias ExpeditionState = GlassState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.service.connection = connection
        
        switch event.type {
        case .listen:
            state.service.mic.startRecording()
        case .player:
            state.service.preparePlayer()
            state.service.startLeVerre()
            break
        }
    }
}

struct GlassStopExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GlassEvents.Glass.Stop
    typealias ExpeditionState = GlassState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.service.stop()
    }
}
