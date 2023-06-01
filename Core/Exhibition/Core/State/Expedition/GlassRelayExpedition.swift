//
//  GlassRelayExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//

import Foundation
import GraniteUI
import Combine

struct GlassListenRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Glass.Listen
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        connection.request(GlassEvents.Glass.Stop())
        GraniteLogger.info("glass started", .expedition, focus: true)
        connection.request(GlassEvents.Glass.Request(type: .listen))
        connection.update(\EnvironmentDependency.exhibition.listening, value: true, .quiet)
    }
}

struct GlassPlayerRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Glass.Player
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("glass player started", .expedition, focus: true)
        connection.request(GlassEvents.Glass.Request(type: .player))
        connection.update(\EnvironmentDependency.exhibition.listening, value: true, .quiet)
    }
}

struct GlassPingRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GlassEvents.Glass.Ping
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        connection.hear(event: event)
    }
}

struct GlassStopRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GlassEvents.Glass.Stop
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        connection.request(event)
    }
}
