//
//  GlassCanvasExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/16/21.
//

import GraniteUI
import Combine
import Foundation
import MarbleKit
import MetalKit

struct GlassCanvasExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GlassEvents.Glass.Ping
    typealias ExpeditionState = CanvasState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.glassSample = event.sample
        state.glassFrames += 1
        if state.glassSample > 12, state.glassFrames > 1200 {
            state.glassFrames = 0
            connection.request(InstallationEvents.Advance(), .contact)
        }
        
        //Prevent Overflow?
        if state.glassFrames > 120000 {
            state.glassFrames = 0
        }
    }
}
