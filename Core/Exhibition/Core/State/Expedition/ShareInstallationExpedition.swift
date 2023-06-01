//
//  ShareInstallationExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/27/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct ShareInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Share
    typealias ExpeditionState = ExhibitionState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.sharing = event.installation
        
        connection.request(MarbleEvents.Atlas.Stop())
        state.installationsMarbling = 0
    }
}

struct CancelShareInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Share.Cancel
    typealias ExpeditionState = ExhibitionState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.sharing = nil
        
        connection.request(MarbleEvents.Atlas.Stop())
        state.installationsMarbling = 0
    }
}
