//
//  MarbleRelayExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/24/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct MarbleFilterRelayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CanvasEvents.Filter.Update
    typealias ExpeditionState = ExhibitionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        connection.hear(event: event)
    }
}
