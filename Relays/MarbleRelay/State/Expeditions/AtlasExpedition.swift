//
//  AtlasExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//
import GraniteUI
import Combine
import MarbleKit
import Foundation

struct AtlasExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarbleEvents.Atlas.Request
    typealias ExpeditionState = MarbleState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.atlas == nil else { return }
        let atlas: Atlas = .init({ _ in connection.request(MarbleEvents.Atlas.Ping()) })
        state.atlas = atlas
        state.atlas?.start()
    }
}

struct AtlasStopExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarbleEvents.Atlas.Stop
    typealias ExpeditionState = MarbleState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.atlas?.stop()
        state.atlas = nil
    }
}
