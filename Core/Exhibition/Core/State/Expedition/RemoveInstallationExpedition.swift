//
//  RemoveExhibitionExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 4/21/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct RemoveInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Remove
    typealias ExpeditionState = ExhibitionState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        event.installation.remove(moc: coreDataInstance)
        
        state.sharing = nil
        
        connection.request(MarbleEvents.Atlas.Stop())
        state.installationsMarbling = 0
        
        state.installations.removeAll(where: { $0.ipfsHash == event.installation.ipfsHash })
        
        connection.request(ExhibitionEvents.Prepare.init(installations: state.installations))
    }
}
