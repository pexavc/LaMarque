//
//  AddMarqueExpedition.swift
//  marble
//
//  Created by PEXAVC on 2/26/21.
//  Copyright (c) 2021 Stoic Collective, LLC.. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct AddMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Add
    typealias ExpeditionState = MarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let url = URL.init(fileURLWithPath: event.path)
        if let data = try? Data.init(contentsOf: url) {
            if let image = GraniteImage.init(data: data) {
                
                //[CAN REMOVE] uses marquekit for encoding
//                state.service.kit.encode(event.signature,
//                                         withObject: image) { result in
//
//                    if let data = result.data.pngData() {
//                        do {
//                            GraniteLogger.info("adding marque via signed data", .expedition, focus: true)
//                            try state.service.client?.add(data) { nodes in
//                                connection.request(MarqueEvents.Pin(nodes: nodes, encodedData: data))
//                            }
//                        } catch let error {
//                            GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
//                        }
//                    }
//
//                }
            }
        } else {
            GraniteLogger.info("adding marque via path", .expedition, focus: true)
            do {
                try state.service.client?.add(event.path) { nodes in
                    connection.request(MarqueEvents.Pin(nodes: nodes, encodedData: .init()))
                }
            } catch let error {
                GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
            }
        }
    }
}

struct AddSiteMarqueExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MarqueEvents.Add.Site
    typealias ExpeditionState = MarqueState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("adding marque site via path", .expedition, focus: true)
        do {
//            if event.oldSiteID.isNotEmpty, let mh = try? fromB58String(event.oldSiteID) {
//                print("{TEST} \(event.oldSiteID)")
//                try state.service.client?.pin.rm(mh, recursive: false) { result in
//                    //removed old site
//                    print("{TEST} \(event.oldSiteID)")
//                    do {
//                        try state.service.client?.add(event.path) { nodes in
//                            connection.request(MarqueEvents.Pin.Site(nodes: nodes))
//                        }
//                    } catch let error {
//                        GraniteLogger.info("error adding new site after removing:\n\(error)", .expedition, focus: true)
//                    }
//                }
//            } else {
//
//                try state.service.client?.add(event.path) { nodes in
//                    connection.request(MarqueEvents.Pin.Site(nodes: nodes))
//                }
//            }
            try state.service.client?.add(event.path) { nodes in
                connection.request(MarqueEvents.Pin.Site(nodes: nodes))
            }
        } catch let error {
            GraniteLogger.info("error adding new site:\n\(error)", .expedition, focus: true)
        }
    }
}
