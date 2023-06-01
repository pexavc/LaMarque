//
//  RadioExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/19/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct RadioExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ListenEvents.Radio.Begin
    typealias ExpeditionState = ListenState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.request(ExhibitionEvents.Glass.Player(), .contact)
        state.wantsToListen = false
        state.stage = .listening
    }
}
