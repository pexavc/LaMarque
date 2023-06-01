//
//  CollectMarqueExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/28/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct CollectMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Collect
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let verification = state.verification else {
            return
        }
        
        let result = coreDataInstance.get(Installation.getObjectRequest(id: verification.hash))
        
        if (result.isEmpty) {
            let installation: Installation = .init(verification.hash,
                                                   name: verification.creativeName,
                                                   author: verification.creativeAuthor,
                                                   creativeData: verification.creativeData,
                                                   isCollected: true)
            
            coreDataInstance.save(installation)
            
            state.stage = .collected
        } else {
            state.stage = .alreadyCollected
        }
        
        connection.request(LaMarqueEvents.Site())
    }
}
