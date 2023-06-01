//
//  GenerateMarqueExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct GenerateLaMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Generate
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.data.isReady else { return }

        connection.request(MarqueEvents.Add(path: state.data.path, signature: state.data.signature), .rebound)
        
        GraniteLogger.info("adding image", .expedition, focus: true)
        
        state.stage = .generating
    }
}

struct MarqueResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Pin.Result
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let hash = b58String(event.pinHash)
        
        let objects = coreDataInstance.get(Installation.getObjectRequest(id: hash))
        
        if objects.isEmpty {
            let installation: Installation = .init(b58String(event.pinHash),
                                                   name: state.data.name,
                                                   author: storage.get(GlobalDefaults.ExhibitionName, defaultValue: "La Marque::\(Date.today.asString)"),
                                                   creativeData: event.encodedData)
            
            coreDataInstance.save(installation)
            
            state.stage = .none
            
            GraniteLogger.info("pin result", .expedition, focus: true)
            
            connection.request(LaMarqueEvents.Site())
        } else {
            connection.request(LaMarqueEvents.Exists())
        }
    }
}

struct MarqueResultExistsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Exists
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.stage = .alreadyExists
    }
}

struct GenerateSiteMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LaMarqueEvents.Site
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let exhibitionId: String = storage.get(GlobalDefaults.ExhibitionID, defaultValue: "invalid")
        let exhibitionSite: String = storage.get(GlobalDefaults.ExhibitionSite, defaultValue: "")
        let curator: String = storage.get(GlobalDefaults.ExhibitionName, defaultValue: "La Marque::\(Date.today.asString)")
        let site = MarqueSite(exhibitionId: exhibitionId, exhibitionCurator: curator)
        let objects = coreDataInstance.get(Installation.getObjectRequest())
        let installations = objects.map { $0.asSelf }
        let result = site.generate(installations)

        guard let path = result else {
            
            connection.request(ExhibitionEvents.Get(), .contact);
            return
        }

        connection.request(MarqueEvents.Add.Site.init(path: path, oldSiteID: exhibitionSite), .rebound)
    }
}

struct GenerateSiteResultMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Pin.Site.Result
    typealias ExpeditionState = LaMarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("pinning site", .expedition, focus: true)
        storage.update(GlobalDefaults.ExhibitionSite, b58String(event.pinHash))
        
        connection.request(ExhibitionEvents.Get(), .contact)
    }
}
