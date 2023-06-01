//
//  SetupSceneExpedition.swift
//  stoic
//
//  Created by PEXAVC on 2/1/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import Combine
import Foundation

struct SetupSceneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SpecialEvents.Start
    typealias ExpeditionState = SpecialState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        state.scene.run()
    }
}
