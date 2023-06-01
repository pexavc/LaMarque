//
//  CleanExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/24/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct StopExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ListenEvents.Stop
    typealias ExpeditionState = ListenState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        connection.request(GlassEvents.Glass.Stop(), .contact)
        state.wantsToListen = false
        state.stage = .none
    }
}
