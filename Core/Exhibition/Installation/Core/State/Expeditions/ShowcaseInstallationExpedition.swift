//
//  ShowcaseInstallationExpedition.swift
//  lamarque
//
//  Created by PEXAVC on 3/24/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct ShowcaseInstallationExpedition: GraniteExpedition {
    typealias ExpeditionEvent = InstallationEvents.Advance
    typealias ExpeditionState = InstallationState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        guard state.installations.isNotEmpty else { return }
        
        let installation = state.installations[state.showcaseIndex]
        state.installation = installation
        state.originalImage = installation.originalImage
        
        let nextIndex = state.showcaseIndex + 1
        if nextIndex < state.installations.count {
            state.showcaseIndex = nextIndex
        } else {
            state.showcaseIndex = 0
        }
        
        connection.hear(event: CanvasEvents.Prepare.init(installation: installation))
    }
}
