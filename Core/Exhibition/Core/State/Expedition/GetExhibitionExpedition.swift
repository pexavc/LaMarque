//
//  GetExhibitionExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct GetExhibitionExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Get
    typealias ExpeditionState = ExhibitionState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let result = coreDataInstance.get(Installation.getObjectRequest())
        
        GraniteLogger.info("found \(result.count) installations", .expedition, focus: true)
        connection.request(ExhibitionEvents.Prepare(installations: result.map { $0.asSelf }.reversed()))
        
        connection.request(MarbleEvents.Atlas.Stop())
        state.installationsMarbling = 0
    }
}

struct PrepareExhibitionExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExhibitionEvents.Prepare
    typealias ExpeditionState = ExhibitionState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.installations = event.installations
        
        connection.update(\EnvironmentDependency.exhibition.intent, value: state.intent)
        
        if state.intent == .showcase {
            state.stage = .marbling
        }
        
        guard !EnvironmentConfig.isIPhone else { state.prepared = true; return }
        
        let installations: [Installation] = event.installations
        
        var finalArrangement: [[Installation]] = []
        var currentArrangement: [Installation] = []
        
        for installation in installations {
            if installation.isLandscape {
                if currentArrangement.isNotEmpty {
                    finalArrangement.append(currentArrangement)
                    currentArrangement.removeAll()
                }
                finalArrangement.append([installation])
            } else {
                currentArrangement.append(installation)
            }
            
            if currentArrangement.count == 3 {
                finalArrangement.append(currentArrangement)
                currentArrangement.removeAll()
            }
        }
        
        if currentArrangement.isNotEmpty {
            finalArrangement.append(currentArrangement)
            currentArrangement.removeAll()
        }
        
        state.arrangement = finalArrangement
        
        state.prepared = true
    }
}
